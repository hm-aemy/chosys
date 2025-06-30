#LLVM

mkdir -p ./circt/llvm/build;
pushd ./circt/llvm/build;
cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS="mlir"  \
  -DLLVM_TARGETS_TO_BUILD="host"   \
  -DLLVM_ENABLE_ASSERTIONS=ON  \
  -DCMAKE_BUILD_TYPE=DEBUG   \
  -DLLVM_USE_SPLIT_DWARF=ON   \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DLLVM_PARALLEL_COMPILE_JOBS=16 \
  -DLLVM_OPTIMIZED_TABLEGEN=ON;
ninja;
popd;

#CIRCT
mkdir -p ./circt/build;
pushd ./circt/build;
cmake .. --preset debug;
ninja;
popd;

#rtlil-emit

mkdir -p ./rtlil-emit/build;
pushd ./rtlil-emit/build;
cmake .. --preset debug;
ninja;
popd;