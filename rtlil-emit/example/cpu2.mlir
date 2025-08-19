module {
  module @"\\and1_1" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\arg2_1", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\arg0_1", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\res_1", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%1, %0, %2) <{name = "$2", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
  module @"\\and2_3" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\arg2_3", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\arg0_3", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\res_3", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%1, %0, %2) <{name = "$4", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
  module @"\\top_5" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\reset_5", port_id = 4 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\arg2_5", port_id = 2 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\arg0_5", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    %3 = "rtlil.wire"() <{is_signed = false, name = "\\clock_5", port_id = 0 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>
    %4 = "rtlil.wire"() <{is_signed = false, name = "$%4", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.instance"(%2, %1, %4) <{name = "\\inst1_6", parameters = [], ports = ["\\arg0_1", "\\arg2_1", "\\res_1"], type = @"\\and1_1"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %5 = "rtlil.wire"() <{is_signed = false, name = "$%6", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.instance"(%4, %2, %5) <{name = "\\inst2_7", parameters = [], ports = ["\\arg0_3", "\\arg2_3", "\\res_3"], type = @"\\and2_3"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %6 = "rtlil.wire"() <{is_signed = false, name = "\\res_5", port_id = 3 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.cell"(%4, %5, %6) <{name = "$8", parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 32 : i32>, #rtlil<param "\\B_SIGNED" 0 : i32>, #rtlil<param "\\B_WIDTH" 32 : i32>, #rtlil<param "\\Y_WIDTH" 32 : i32>], ports = ["\\A", "\\B", "\\Y"], type = "$and"}> : (!rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %7 = "rtlil.wire"() <{is_signed = false, name = "$10", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.dff"(%3, %6, %7) <{name = "\\reg0_9", ports = ["\\CLK", "\\D", "\\Q"], type = "$dff", width = 32 : i32}> : (!rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
    %8 = "rtlil.wire"() <{is_signed = false, name = "$12", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false, width = 32 : i32}> : () -> !rtlil<val[32 : i32]>
    "rtlil.aldff"(%3, %6, %0, %4, %8) <{name = "$11", ports = ["\\CLK", "\\D", "\\ALOAD", "\\AD", "\\Q"], type = "$aldff", width = 32 : i32}> : (!rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[1 : i32]>, !rtlil<val[32 : i32]>, !rtlil<val[32 : i32]>) -> ()
  }
}

