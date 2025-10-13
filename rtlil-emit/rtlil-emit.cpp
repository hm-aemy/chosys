#include "circt/Support/LLVM.h"
#include "mlir/ExecutionEngine/ExecutionEngine.h"
#include "mlir/IR/AsmState.h"
#include "mlir/IR/Attributes.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/IR/Verifier.h"
#include "mlir/IR/AsmState.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Bytecode/BytecodeReader.h"
#include "mlir/Bytecode/BytecodeWriter.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Target/LLVMIR/Dialect/Builtin/BuiltinToLLVMIRTranslation.h"
#include "mlir/Target/LLVMIR/Dialect/LLVMIR/LLVMToLLVMIRTranslation.h"
#include "mlir/Target/LLVMIR/Export.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_os_ostream.h"
#include "llvm/Support/raw_ostream.h"

#include "circt/Dialect/RTLIL/RTLIL.h"
#include "circt/Conversion/ExportVerilog.h"

// Malarkey - I think this is just not generally exposed?
// TODO move elsewhere?
using namespace circt;
namespace mlir {
class ModuleOp;
}; // namespace mlir

#include "kernel/yosys.h"
USING_YOSYS_NAMESPACE

// TODO This is awful naming, what's the nomenclature?
// From the MLIR perspective this is an importer, but it's a yosys backend
class MLIRifier {
  mlir::MLIRContext &ctx;
  mlir::OpBuilder b;
  mlir::Location loc;
  // This is really stupid actually
  llvm::DenseMap<RTLIL::Wire *, rtlil::WireOp> wiremap;

public:
  mlir::ModuleOp fake_top;
  MLIRifier(mlir::MLIRContext &context)
      : ctx(context), b(mlir::OpBuilder(&context)), loc(b.getUnknownLoc()) {
        fake_top = mlir::ModuleOp(mlir::ModuleOp::create(loc));
      }

  rtlil::WireOp convert_wire(RTLIL::Wire *wire) {
    log_debug("converting wire %s\n", log_id(wire));
    log_assert(!wiremap.contains(wire));
    auto [wire_loc, wireattrs] = convert_attrs(wire, wire->name);
    return wiremap[wire] = b.create<rtlil::WireOp>(
               wire_loc,
               rtlil::MValueType::get(
                   &ctx, mlir::IntegerAttr::get(b.getI32Type(), wire->width)),
               mlir::StringAttr::get(&ctx, wire->name.c_str()),
               mlir::BoolAttr::get(&ctx, wire->is_signed),
               mlir::IntegerAttr::get(b.getI32Type(), wire->port_id),
               mlir::IntegerAttr::get(b.getI32Type(), wire->start_offset),
               mlir::BoolAttr::get(&ctx, wire->port_input),
               mlir::BoolAttr::get(&ctx, wire->port_output),
               mlir::BoolAttr::get(&ctx, wire->upto),
               wireattrs);
  }

  rtlil::ConstOp convert_const_sig(RTLIL::Const *c) {
    log_debug("converting const sig %s\n", log_const(*c));
    std::vector<mlir::Attribute> const_bits;
    for (State bit : *c)
      const_bits.push_back(
          rtlil::StateEnumAttr::get(&ctx, (rtlil::StateEnum)bit));
    mlir::ArrayAttr aa = b.getArrayAttr(const_bits);
    // TODO flags?
    return b.create<rtlil::ConstOp>(
        loc,
        rtlil::MValueType::get(
            &ctx, mlir::IntegerAttr::get(b.getI32Type(), const_bits.size())),
        (mlir::ArrayAttr)aa);
  }

  mlir::Value convert_sigspec(RTLIL::SigSpec sigspec) {
    log_debug("converting sigspec %s\n", log_signal(sigspec));
    if (sigspec.is_fully_const()) {
      std::vector<mlir::Attribute> const_bits;
      RTLIL::Const domain_const = sigspec.as_const();
      rtlil::ConstOp c = convert_const_sig(&domain_const);
      log_assert(mlir::verify(c).succeeded());
      return c.getResult();
    } else if (sigspec.is_wire()) {
      RTLIL::Wire *wire = sigspec.as_wire();
      log_assert(wiremap.contains(wire));
      return wiremap[wire].getResult();
    } else {
      log_error("Found SigSpec that isn't a constant or full wire "
                "connection, did you run splice?\n");
    }
  }

  mlir::Attribute convert_const(RTLIL::Const& c) {
    if (c.flags & RTLIL::ConstFlags::CONST_FLAG_STRING) {
      return mlir::StringAttr::get(&ctx, c.decode_string());
    } else {
      if (auto i = c.try_as_int(true)) {
        auto signedness = c.flags & RTLIL::CONST_FLAG_SIGNED ? mlir::IntegerType::Signed : mlir::IntegerType::Unsigned;
        mlir::Type itype = mlir::IntegerType::get(&ctx, c.size(), signedness);
        return mlir::IntegerAttr::get(itype, *i);
      } else {
        log_error("Unsupported const %s\n", log_const(c));
      }
    }
  }
  std::tuple<mlir::Location, mlir::DictionaryAttr> convert_attrs(RTLIL::AttrObject *obj, const IdString& obj_name) {
    auto obj_loc = loc;
    std::vector<mlir::NamedAttribute> attrs;
    for (auto& [name, value] : obj->attributes) {
      mlir::StringAttr attrname = mlir::StringAttr::get(&ctx, name.c_str());
      auto attrvalue = convert_const(value);
      if (name.str() == "\\src") {
        if (auto s = dyn_cast<mlir::StringAttr>(attrvalue)) {
          obj_loc = mlir::FileLineColRange::get(s);
          continue;
        }
      } else {
        attrs.push_back(b.getNamedAttr(attrname, attrvalue));
      }
    }
    return std::make_tuple(obj_loc, b.getDictionaryAttr(attrs));
  }

  rtlil::CellOp convert_cell(RTLIL::Cell *cell) {
    log_debug("converting cell %s\n", log_id(cell));

    std::vector<mlir::Attribute> signature;
    std::vector<mlir::Value> connections;
    for (auto [port, sigspec] : cell->connections()) {
      auto val = convert_sigspec(sigspec);
      connections.push_back(val);
      auto portname = std::string(port.c_str());
      auto portattr = mlir::StringAttr::get(&ctx, portname);
      signature.push_back(portattr);
    }
    mlir::ArrayAttr cellsignature = b.getArrayAttr(signature);

    std::vector<mlir::Attribute> parameters;
    for (auto [param, value] : cell->parameters) {
      log_assert(value.convertible_to_int());
      log_assert(value.is_fully_def());
      auto paramname = mlir::StringAttr::get(&ctx, param.c_str());
      mlir::Type itype = mlir::IntegerType::get(&ctx, value.size());
      auto paramvalue = mlir::IntegerAttr::get(itype, value.as_int());
      auto parameter = rtlil::ParameterAttr::get(&ctx, paramname, paramvalue);
      parameters.push_back(parameter);
    }
    mlir::ArrayAttr cellparameters = b.getArrayAttr(parameters);

    auto [cell_loc, cellattrs] = convert_attrs(cell, cell->name);

    mlir::StringAttr cellname = mlir::StringAttr::get(&ctx, cell->name.c_str());
    mlir::StringAttr celltype = mlir::StringAttr::get(&ctx, cell->type.c_str());
    return b.create<rtlil::CellOp>(cell_loc, cellname, celltype, connections,
                                   cellsignature, cellparameters, cellattrs);
  }

  rtlil::WConnectionOp convert_connection(RTLIL::SigSig ss) {
    log_debug("converting connection %s %s\n", log_signal(ss.first),
              log_signal(ss.second));
    return b.create<rtlil::WConnectionOp>(loc, convert_sigspec(ss.first),
                                          convert_sigspec(ss.second));
  }

  void convert_module(RTLIL::Module *mod) {
    log_debug("converting module %s\n", log_id(mod));
    auto [mod_loc, modattrs] = convert_attrs(mod, mod->name);
    if (!modattrs.empty())
      log_warning("Module %s has general attributes, which isn't yet supported\n", mod->name);
    mlir::ModuleOp moduleOp(mlir::ModuleOp::create(mod_loc, mod->name.c_str()));
    b.setInsertionPointToStart(moduleOp.getBody());
    for (auto wire : mod->wires()) {
      log_assert(mlir::verify(convert_wire(wire)).succeeded());
    }
    for (auto cell : mod->cells()) {
      log_assert(mlir::verify(convert_cell(cell)).succeeded());
    }
    for (auto conn : mod->connections()) {
      log_assert(mlir::verify(convert_connection(conn)).succeeded());
    }
    fake_top.push_back(moduleOp);
  }
};

struct MlirBackend : public Backend {
  MlirBackend() : Backend("mlir", "Write design as MLIR RTLIL dialect") {}
  // TODO help
  void execute(std::ostream *&f, std::string filename,
               std::vector<std::string> args, RTLIL::Design *design) override {
    log_header(design, "Executing MLIR backend.\n");
    size_t argidx;
    bool asm_mode = false;
    for (argidx = 1; argidx < args.size(); argidx++) {
      std::string arg = args[argidx];
      if (arg == "-bc") {
        asm_mode = false;
        continue;
      }
      if (arg == "-asm") {
        asm_mode = true;
        continue;
      }
      break;
    }
    extra_args(f, filename, args, argidx);
    log_debug("asm: %d filename %s\n", asm_mode, filename);
    llvm::raw_os_ostream osos(*f);
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<rtlil::RTLILDialect>();
    MLIRifier convertor(ctx);
    mlir::OpPrintingFlags flags;
    flags.enableDebugInfo(/*enable=*/true, /*prettyForm=*/false);
    for (auto mod : design->selected_modules()) {
      convertor.convert_module(mod);
    }
    // TODO: optional bitcode
    if (asm_mode)
      convertor.fake_top.print(osos, flags);
    else {
      llvm::StringRef producer = yosys_maybe_version();
      auto res = mlir::writeBytecodeToFile(convertor.fake_top,
                                          osos,
                                          mlir::BytecodeWriterConfig(producer));
      if (res.failed())
        log_error("Failed to convert RTLIL\n");
    }
  }
} MlirBackend;

class RTLILifier {
  RTLIL::Design *design;
  RTLIL::Const convert_const_sig(rtlil::ConstOp op) {
    std::vector<RTLIL::State> bits;
    for (auto bit : op.getValueAttr()) {
      unsigned char raw = llvm::cast<rtlil::StateEnumAttr>(bit).getInt();
      log_assert(rtlil::symbolizeStateEnum(raw).has_value());
      bits.push_back(static_cast<RTLIL::State>(raw));
    }
    return Const(bits);
  }
  RTLIL::SigSpec convert_signal(RTLIL::Module *mod, mlir::Value v) {
    mlir::Operation *def = v.getDefiningOp();
    if (auto constOp = mlir::dyn_cast<rtlil::ConstOp>(def)) {
      return convert_const_sig(constOp);
    } else if (auto wireOp = mlir::dyn_cast<rtlil::WireOp>(def)) {
      std::string wireName =
          llvm::cast<mlir::StringAttr>(wireOp.getNameAttr()).str();
      RTLIL::Wire *wire = mod->wire(wireName);
      if (!wire)
        log_error("Unknown wire: %s\n", wireName.c_str());
      return wire;
    } else {
      def->dump();
      log_error("Unhandled RTLIL dialect value producing op\n");
    }
  }
  RTLIL::Const convert_const(mlir::Attribute value, bool is_param) {
    Const c;
    if (auto s = mlir::dyn_cast<mlir::StringAttr>(value)) {
      log_debug("string\n");
      c = std::string(s.getValue());
      c.flags |= RTLIL::ConstFlags::CONST_FLAG_STRING;
    } else if (auto b = mlir::dyn_cast<mlir::BoolAttr>(value)) {
      log_debug("bool\n");
      c = Const(b.getValue(), 1);
    } else if (auto i = mlir::dyn_cast<mlir::IntegerAttr>(value)) {
      log_debug("int\n");
      mlir::Type itype = i.getType();
      auto iwidth = itype.getIntOrFloatBitWidth();
      if (itype.isSignedInteger()) {
        c = Const((long long)i.getSInt(), iwidth);
        if (is_param)
          c.flags |= RTLIL::ConstFlags::CONST_FLAG_SIGNED;
      } else if (itype.isUnsignedInteger()) {
        c = Const((long long)i.getUInt(), iwidth);
      } else if (itype.isSignlessInteger()) {
        c = Const((long long)i.getInt(), iwidth);
      } else {
        i.dump();
        log_error("Weird integer\n");
      }
    } else if (auto arr_attr = mlir::dyn_cast<mlir::ArrayAttr>(value)) {
      log_debug("array\n");
      llvm::ArrayRef arr_ref = arr_attr.getValue();
      std::vector<RTLIL::State> v;
      for (auto element : arr_ref) {
        if (auto i = mlir::dyn_cast<rtlil::StateEnumAttr>(element)) {
          v.push_back((RTLIL::State)i.getValue());
        } else {
          value.dump();
          log_error("Array attribute contains elements other than RTLIL State\n");
        }
      }
      c = (std::move(v));
    } else {
      value.dump();
      log_error("Attribute value has unknown type\n", value.getTypeID());
    }
    return c;
  }
  void convert_attrs(RTLIL::AttrObject* obj, mlir::DictionaryAttr attrs, const IdString& obj_name) {
    for (auto attr : attrs) {
      std::string name = attr.getName().str();
      log_debug("attribute %s on object %s\n", name, obj_name);
      obj->attributes[name] = convert_const(attr.getValue(), false);
    }
  }
  void convert_loc(RTLIL::AttrObject* obj, const mlir::Location& loc) {
    auto emitter = LocationEmitter(LoweringOptions::LocationInfoStyle::Plain, loc);
    auto loc_str = emitter.strref();
    if (!loc_str.empty())
      obj->attributes[RTLIL::ID::src] = RTLIL::Const(loc_str.data());
  }

public:
  RTLILifier(RTLIL::Design *d) : design(d) {}
  void convert_wire(RTLIL::Module *mod, rtlil::WireOp op) {
    RTLIL::Wire *w = mod->addWire(std::string(op.getName()));
    w->width = op.getWidth().getInt();
    w->start_offset = op.getStartOffset();
    w->port_id = op.getPortId();
    w->port_input = op.getPortInput();
    w->port_output = op.getPortOutput();
    w->upto = op.getUpto();
    w->is_signed = op.getIsSigned();
    convert_loc(w, op.getLoc());
    convert_attrs(w, op.getExtraAttrs(), w->name);
  }
  void convert_cell(RTLIL::Module *mod, rtlil::CellOpInterface op) {
    RTLIL::Cell *c = mod->addCell(std::string(op.getCellName()),
                                  std::string(op.getCellType()));
    convert_loc(c, op.getLoc());
    std::vector<std::string> signature;
    for (auto port : op.getCellPorts()) {
      std::string portName = llvm::cast<mlir::StringAttr>(port).str();
      signature.push_back(portName);
    }
    for (const auto &it : llvm::enumerate(op.getCellConnections())) {
      auto conn = it.value();
      log_assert(it.index() < signature.size());
      auto portName = signature[it.index()];
      c->setPort(portName, convert_signal(mod, conn));
    }
    for (auto param : op.getCellParameters()) {
      auto paramAttr = llvm::cast<rtlil::ParameterAttr>(param);
      std::string paramName = paramAttr.getName().str();
      c->setParam(paramName, convert_const(paramAttr.getValue(), true));
    }
    convert_loc(c, op.getLoc());
    convert_attrs(c, op.getCellExtraAttrs(), c->name);
  }
  void convert_connection(RTLIL::Module *mod, rtlil::WConnectionOp op) {
    mlir::Value lhs = op.getLhs();
    mlir::Value rhs = op.getRhs();
    mod->connect(convert_signal(mod, lhs), convert_signal(mod, rhs));
  }

  void convert_module(mlir::ModuleOp moduleOp) {
    llvm::StringRef moduleName = moduleOp.getName().value_or("");
    log_assert((moduleName.size() != 0) &&
               "Unnamed module op in RTLIL dialect");
    RTLIL::Module *new_module = design->addModule(moduleName.str());
    for (auto &op : moduleOp.getBody()->getOperations()) {
      if (auto wireOp = mlir::dyn_cast<rtlil::WireOp>(op)) {
        convert_wire(new_module, wireOp);
      } else if (auto cellOp = mlir::dyn_cast<rtlil::CellOpInterface>(op)) {
        convert_cell(new_module, cellOp);
      } else if (auto connOp = mlir::dyn_cast<rtlil::WConnectionOp>(op)) {
        convert_connection(new_module, connOp);
      } else if (auto constOp = mlir::dyn_cast<rtlil::ConstOp>(op)) {
        // skip, we do this on demand
      } else {
        op.dump();
        log_error("Unhandled RTLIL dialect op\n");
      }
    }
    new_module->fixup_ports();
  }
};

struct MlirFrontend : public Frontend {
  MlirFrontend() : Frontend("mlir", "Read design from MLIR RTLIL dialect") {}
  // TODO help
  void execute(std::istream *&f, std::string filename,
               std::vector<std::string> args, RTLIL::Design *design) override {
    log_header(design, "Executing MLIR frontend.\n");
    size_t argidx;
    for (argidx = 1; argidx < args.size(); argidx++) {
      break;
    }
    extra_args(f, filename, args, argidx);
    mlir::MLIRContext ctx;
    ctx.getOrLoadDialect<rtlil::RTLILDialect>();
    llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> fileOrErr =
        llvm::MemoryBuffer::getFileOrSTDIN(filename);
    if (std::error_code ec = fileOrErr.getError()) {
      llvm::errs() << "Could not open input file: " << ec.message() << "\n";
    }

    // Parse the input mlir.
    llvm::SourceMgr sourceMgr;
    sourceMgr.AddNewSourceBuffer(std::move(*fileOrErr), llvm::SMLoc());
    mlir::OwningOpRef<mlir::ModuleOp> owningModule =
        mlir::parseSourceFile<mlir::ModuleOp>(sourceMgr, &ctx);
    if (!owningModule) {
      llvm::errs() << "Error can't load file " << filename << "\n";
      log_abort();
    }
    auto moduleOp = std::make_shared<mlir::ModuleOp>(owningModule.release());
    RTLILifier convertor(design);
    for (auto &operation : moduleOp->getOps()) {
      mlir::ModuleOp op = llvm::dyn_cast<mlir::ModuleOp>(operation);
      if (!op)
        log_assert(false && "Top level MLIR entity isn't a module");
      convertor.convert_module(op);
    }
  }
} MlirFrontend;
