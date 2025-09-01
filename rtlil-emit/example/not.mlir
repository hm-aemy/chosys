// yosys -m rtlil-emit/build/librtlil-emit.so -p "read_mlir rtlil-emit/example/not.mlir; dump"
module {
  module @"\\not" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\i1", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>  loc ("foo.bar":1:2)
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\o1", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>
    "rtlil.cell"(%0, %1) <{name = "$2", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 1 : i32>, #rtlil<param "\\Y_WIDTH" 1 : i32>], ports = ["\\A", "\\Y"], type = "$not", extraAttrs = {"\\x" = "y"}}> : (!rtlil<val[1 : i32]>, !rtlil<val[1 : i32]>) -> ()
  }
}

