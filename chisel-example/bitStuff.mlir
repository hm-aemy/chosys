module {
  module @"\\BitStuff_1" {
    %0 = "rtlil.wire"() <{is_signed = false, name = "\\c_1", port_id = 5 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[2 : i32]>
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\b_1", port_id = 4 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    %2 = "rtlil.wire"() <{is_signed = false, name = "\\a_1", port_id = 3 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[8 : i32]>
    %3 = "rtlil.wire"() <{is_signed = false, name = "\\reset_1", port_id = 2 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[1 : i32]>
    %4 = "rtlil.wire"() <{is_signed = false, name = "\\clock_1", port_id = 1 : i32, port_input = true, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[1 : i32]>
    %5 = "rtlil.const"() <{value = [0 : i8, 0 : i8]}> : () -> !rtlil<val[2 : i32]>
    %6 = "rtlil.const"() <{value = [0 : i8, 0 : i8, 0 : i8]}> : () -> !rtlil<val[3 : i32]>
    %7 = "rtlil.const"() <{value = [0 : i8]}> : () -> !rtlil<val[1 : i32]>
    %8 = "rtlil.wire"() <{is_signed = false, name = "$2", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    "rtlil.slice"(%2, %8) <{name = "$3", offset = 0 : i32, ports = ["\\A", "\\Y"], type = "$slice", widthA = 8 : i32, widthY = 4 : i32}> : (!rtlil<val[8 : i32]>, !rtlil<val[4 : i32]>) -> ()
    %9 = "rtlil.wire"() <{is_signed = false, name = "$4", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    "rtlil.and"(%8, %1, %9) <{name = "$5", opsSigned = 0 : i32, ports = ["\\A", "\\B", "\\Y"], type = "$and", width = 4 : i32}> : (!rtlil<val[4 : i32]>, !rtlil<val[4 : i32]>, !rtlil<val[4 : i32]>) -> ()
    %10 = "rtlil.wire"() <{is_signed = false, name = "$7", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[5 : i32]>
    "rtlil.concat"(%9, %7, %10) <{name = "$8", ports = ["\\A", "\\B", "\\Y"], type = "$concat", widthA = 4 : i32, widthB = 1 : i32}> : (!rtlil<val[4 : i32]>, !rtlil<val[1 : i32]>, !rtlil<val[5 : i32]>) -> ()
    %11 = "rtlil.wire"() <{is_signed = false, name = "$10", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[5 : i32]>
    "rtlil.concat"(%0, %6, %11) <{name = "$11", ports = ["\\A", "\\B", "\\Y"], type = "$concat", widthA = 2 : i32, widthB = 3 : i32}> : (!rtlil<val[2 : i32]>, !rtlil<val[3 : i32]>, !rtlil<val[5 : i32]>) -> ()
    %12 = "rtlil.wire"() <{is_signed = false, name = "$12", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[5 : i32]>
    "rtlil.add"(%10, %11, %12) <{name = "$13", opsSigned = 0 : i32, ports = ["\\A", "\\B", "\\Y"], type = "$add", width = 5 : i32}> : (!rtlil<val[5 : i32]>, !rtlil<val[5 : i32]>, !rtlil<val[5 : i32]>) -> ()
    %13 = "rtlil.wire"() <{is_signed = false, name = "$15", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[8 : i32]>
    "rtlil.concat"(%12, %6, %13) <{name = "$16", ports = ["\\A", "\\B", "\\Y"], type = "$concat", widthA = 5 : i32, widthB = 3 : i32}> : (!rtlil<val[5 : i32]>, !rtlil<val[3 : i32]>, !rtlil<val[8 : i32]>) -> ()
    %14 = "rtlil.wire"() <{is_signed = false, name = "$17", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[8 : i32]>
    "rtlil.add"(%13, %2, %14) <{name = "$18", opsSigned = 0 : i32, ports = ["\\A", "\\B", "\\Y"], type = "$add", width = 8 : i32}> : (!rtlil<val[8 : i32]>, !rtlil<val[8 : i32]>, !rtlil<val[8 : i32]>) -> ()
    %15 = "rtlil.wire"() <{is_signed = false, name = "$19", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    "rtlil.slice"(%14, %15) <{name = "$20", offset = 4 : i32, ports = ["\\A", "\\Y"], type = "$slice", widthA = 8 : i32, widthY = 4 : i32}> : (!rtlil<val[8 : i32]>, !rtlil<val[4 : i32]>) -> ()
    %16 = "rtlil.wire"() <{is_signed = false, name = "$21", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    "rtlil.slice"(%14, %16) <{name = "$22", offset = 0 : i32, ports = ["\\A", "\\Y"], type = "$slice", widthA = 8 : i32, widthY = 4 : i32}> : (!rtlil<val[8 : i32]>, !rtlil<val[4 : i32]>) -> ()
    %17 = "rtlil.wire"() <{is_signed = false, name = "$23", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[4 : i32]>
    "rtlil.or"(%16, %1, %17) <{name = "$24", opsSigned = 0 : i32, ports = ["\\A", "\\B", "\\Y"], type = "$or", width = 4 : i32}> : (!rtlil<val[4 : i32]>, !rtlil<val[4 : i32]>, !rtlil<val[4 : i32]>) -> ()
    %18 = "rtlil.wire"() <{is_signed = false, name = "$26", port_id = 0 : i32, port_input = false, port_output = false, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[8 : i32]>
    "rtlil.concat"(%17, %15, %18) <{name = "$27", ports = ["\\A", "\\B", "\\Y"], type = "$concat", widthA = 4 : i32, widthB = 4 : i32}> : (!rtlil<val[4 : i32]>, !rtlil<val[4 : i32]>, !rtlil<val[8 : i32]>) -> ()
    %19 = "rtlil.wire"() <{is_signed = false, name = "\\out_1", port_id = 6 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false}> : () -> !rtlil<val[10 : i32]>
    "rtlil.concat"(%18, %5, %19) <{name = "$30", ports = ["\\A", "\\B", "\\Y"], type = "$concat", widthA = 8 : i32, widthB = 2 : i32}> : (!rtlil<val[8 : i32]>, !rtlil<val[2 : i32]>, !rtlil<val[10 : i32]>) -> ()
  }
}
