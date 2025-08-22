module {
  hw.module @and1(in %arg0 : i32, in %arg2 : i32, out res : i32) {
    %c0_i32 = hw.constant 2 : i31
    %0 = comb.and %arg0, %arg2 : i32
    hw.output %0 : i32
  }
  hw.module @and2(in %arg0 : i32, in %arg2 : i32, out res : i32) {
    %0 = comb.and %arg0, %arg2 : i32
    hw.output %0 : i32
  }

  hw.module @top(in %clock: !seq.clock, in %arg0 : i32, in %arg2 : i32, out res: i32, in %reset: i1) {
    %0 = hw.instance "inst1" @and1(arg0: %arg0 : i32,  arg2: %arg2 : i32) -> (res: i32)
    %1 = hw.instance "inst2" @and2(arg0: %0 : i32,  arg2: %arg0 : i32) -> (res: i32)
    %2 = comb.and %0, %1 : i32
    %q = seq.compreg sym @reg0 %2, %clock : i32
    %13 = seq.compreg %2, %clock reset %reset, %0 : i32
    hw.output %2 : i32
  }
}