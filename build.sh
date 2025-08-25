set -euo pipefail
#LLVM

mkdir -p ./circt/llvm/build;
cmake -S ./circt/llvm/llvm -B ./circt/llvm/build -G Ninja \
  -DLLVM_ENABLE_PROJECTS="mlir"  \
  -DLLVM_TARGETS_TO_BUILD="host"   \
  -DLLVM_ENABLE_ASSERTIONS=ON  \
  -DCMAKE_BUILD_TYPE=DEBUG   \
  -DLLVM_USE_SPLIT_DWARF=ON   \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DLLVM_OPTIMIZED_TABLEGEN=ON;
ninja -C ./circt/llvm/build;

#CIRCT
mkdir -p ./circt/build;
cmake -S ./circt -B ./circt/build --preset debug;
ninja -C ./circt/build ;

#rtlil-emit
mkdir -p ./rtlil-emit/build;
cmake -S ./rtlil-emit -B ./rtlil-emit/build --preset debug;
ninja -C ./rtlil-emit/build;