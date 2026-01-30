# Chisel to Yosys example

This example demonstrates a flow starting at a Chisel source, creating a RTLIL
dialect based MLIR file, which is consumed by Yosys and exported as a Verilog
source.

## Usage

### Requirements

- `scala-cli`
- `firtool` in CIRCT build
- `librtlil-emit.so` Yosys module

### Flow

**Chisel**

With the Scala build, the Chisel source will generate an MLIR file containing
operations from the RTLIL dialect.

```sh
scala-cli run bitStuff.scala
```

The output can be found in [bitStuff.mlir](bitStuff.mlir], which is consumed in
the next step.

_Manual Intervention:_ Currently the conversion is adding an empty unrelated
operation, `om.class` to the output, this needs to be manually removed.

**Yosys**

To demonstrate the flow, Yosys will read in the generated source and write out a
Verilog representation.

```sh
yosys -m ../rtlil-emit/build/librtlil-emit.so -p \
 "read_mlir bitStuff.mlir; check; write_verilog bitStuff.v"
```

Or for a Yosys netlist generation flow:

```sh
yosys -m ../rtlil-emit/build/librtlil-emit.so synth_netlist.ys
```
