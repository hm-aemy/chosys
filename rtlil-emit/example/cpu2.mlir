module {
  module @"\\and1" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\and1_arg2", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\and1_arg0", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\and1_res", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%1, %0, %2) <{name = "$%9", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
  module @"\\and2" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\and2_arg2", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\and2_arg0", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\and2_res", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%1, %0, %2) <{name = "$%8", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
  module @"\\top" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\top_reset", port_id = 4 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\top_arg2", port_id = 2 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\top_arg0", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %3 = "rtlil.wire"() <{is_signed = false, name = "\\top_clock", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>
    %4 = "rtlil.wire"() <{is_signed = false, name = "$%4", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.instance"(%2, %1, %4) <{name = "\\inst1", parameters = [], ports = ["\\and1_arg0", "\\and1_arg2", "\\and1_res"], type = @"\\and1"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %5 = "rtlil.wire"() <{is_signed = false, name = "$%6", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.instance"(%4, %2, %5) <{name = "\\inst2", parameters = [], ports = ["\\and2_arg0", "\\and2_arg2", "\\and2_res"], type = @"\\and2"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %6 = "rtlil.wire"() <{is_signed = false, name = "\\top_res", port_id = 3 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%4, %5, %6) <{name = "$%9", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %7 = "rtlil.wire"() <{is_signed = false, name = "$%11", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.dff"(%3, %6, %7) <{name = "\\reg0", ports = ["\\CLK", "\\D", "\\Q"], type = "$dff", width = 32 : i32}> : (!rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %8 = "rtlil.wire"() <{is_signed = false, name = "$%13", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.aldff"(%3, %6, %0, %4, %8) <{name = "\\reg1", ports = ["\\CLK", "\\D", "\\ALOAD", "\\AD", "\\Q"], type = "$aldff", width = 32 : i32}> : (!rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
}

