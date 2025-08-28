module {
  hw.module @top(in %clock : !seq.clock, in %reset : i1, out input_ready : i1, in %input_valid : i1, in %input_bits_x : i32, in %input_bits_y : i32, out output_valid : i1, out output_bits : i32) {
    %c0_i32 = hw.constant 0 : i32
    %false = hw.constant false
    %x = seq.firreg %6 clock %clock reset sync %reset, %c0_i32 {firrtl.random_init_start = 0 : ui64, sv.namehint = "x"} : i32 // saves x on pos edge
    %y = seq.firreg %7 clock %clock reset sync %reset, %c0_i32 {firrtl.random_init_start = 32 : ui64} : i32 // saves y on pos edge. resets on reset to 0
    %startupFlag = seq.firreg %8 clock %clock reset sync %reset, %false {firrtl.random_init_start = 64 : ui64} : i1 // saves startupFlag on pos edge. reset to 0.
    %0 = comb.icmp bin ugt %x, %y : i32
    %1 = comb.sub bin %x, %y {sv.namehint = "_x_T"} : i32
    %2 = comb.mux bin %0, %1, %x : i32 // x > y ? x : x - y;
    %3 = comb.sub bin %y, %x {sv.namehint = "_y_T"} : i32
    %4 = comb.mux bin %0, %y, %3 : i32 // x > y ? y - x : y;
    %5 = comb.and bin %9, %input_valid : i1
    %6 = comb.mux bin %5, %input_bits_x, %2 : i32 // input_valid & y == 0 ? input x : subreg x
    %7 = comb.mux bin %5, %input_bits_y, %4 : i32 // input_valid & y == 0 ? input y : subreg y
    %8 = comb.or %5, %startupFlag : i1 // input_valid & y == 0 OR startupFlag
    %9 = comb.icmp bin eq %y, %c0_i32 {sv.namehint = "input_ready"} : i32 // output: y == 0
    %10 = comb.and bin %startupFlag, %9 {sv.namehint = "output_valid"} : i1 // output: y == 0 and startupFlag
    hw.output %9, %10, %x : i1, i1, i32
  }
}
