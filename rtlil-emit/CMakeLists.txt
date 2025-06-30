cmake_minimum_required(VERSION 3.13.4)
if(POLICY CMP0068)
  cmake_policy(SET CMP0068 NEW)
  set(CMAKE_BUILD_WITH_INSTALL_NAME_DIR ON)
endif()

if(POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()

if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()

if(POLICY CMP0116)
  cmake_policy(SET CMP0116 NEW)
endif()

project(mlir-emit LANGUAGES CXX C)
find_package(CIRCT REQUIRED CONFIG PATHS ../circt/build)

list(APPEND CMAKE_MODULE_PATH "${MLIR_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
list(APPEND CMAKE_MODULE_PATH "${CIRCT_CMAKE_DIR}")

include(TableGen)
include(AddLLVM)
include(AddMLIR)
include(AddCIRCT)
include(HandleLLVMOptions)

include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})
include_directories(${CIRCT_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR}/include)
include_directories(${PROJECT_BINARY_DIR}/include)
link_directories(${LLVM_BUILD_LIBRARY_DIR})
add_definitions(${LLVM_DEFINITIONS})

get_property(dialect_libs GLOBAL PROPERTY CIRCT_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY CIRCT_CONVERSION_LIBS)
set(LIBS
        ${dialect_libs}
        ${conversion_libs}
        CIRCTRTLIL
        MLIRAnalysis
        MLIRCallInterfaces
        MLIRCastInterfaces
        MLIRExecutionEngine
        MLIRIR
        MLIRLLVMCommonConversion
        MLIRLLVMToLLVMIRTranslation
        MLIRMemRefDialect
        MLIRLLVMDialect
        MLIRParser
        MLIRPass
        MLIRSideEffectInterfaces
        MLIRSupport
        MLIRTargetLLVMIRExport
        MLIRTransforms
        MLIROptLib
        )

# yosys-config --exec --cxx --cxxflags --ldflags \
# -o my_cmd.so -shared my_cmd.cc --ldlibs

execute_process(
    COMMAND yosys-config --ldflags
    OUTPUT_VARIABLE YOSYS_LDFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND yosys-config --cxxflags
    OUTPUT_VARIABLE YOSYS_CXXFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
separate_arguments(YOSYS_LDFLAGS_LIST UNIX_COMMAND "${YOSYS_LDFLAGS}")
separate_arguments(YOSYS_CXXFLAGS_LIST UNIX_COMMAND "${YOSYS_CXXFLAGS} -Wno-cast-qual")
add_compile_options(${YOSYS_CXXFLAGS_LIST})
set(LLVM_REQUIRES_EH ON)
# add_llvm_executable(rtlil-opt rtlil-opt.cpp)
add_circt_library(rtlil-emit rtlil-emit.cpp SHARED LINK_LIBS ${YOSYS_LDFLAGS_LIST} -Wl,-z,undefs)
# TODO what are these
# llvm_update_compile_flags(rtlil-opt)
llvm_update_compile_flags(rtlil-emit)
# target_link_libraries(rtlil-opt PRIVATE ${LIBS})
target_link_libraries(rtlil-emit PRIVATE ${LIBS})

# -lstdc++ -lm -lrt -lpython3.12 -ldl -L/nix/store/h8wi6kwl1cywxr3f22836vgrrb11fvlb-libxcrypt-4.4.38/lib -lm -lboost_python312 -lboost_system -lboost_filesystem -lreadline -L/nix/store/ixvjg40bxg59mmzjjgs6f2nf2hbal1y4-libffi-3.4.6/lib/../lib64 -lffi -ldl -lz -L/nix/store/krxc78nx57zn9bggwp4slqif88qc8xd1-tcl-8.6.15/lib -ltcl8.6 -ltclstub8.6


# mlir_check_all_link_libraries(rtlil-opt)
mlir_check_all_link_libraries(rtlil-emit)