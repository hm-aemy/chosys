module {
  hw.module @Foo(in %clock : !seq.clock, in %reset : i1, in %io_in0 : i1, in %io_in1 : i1, out io_out : i1) {
    %0 = comb.and bin %io_in0, %io_in1 {sv.namehint = "io_out"} : i1
    hw.output %0 : i1
  }
  om.class @Foo_Class(%basepath: !om.basepath) {
    om.class.fields 
  }
}
