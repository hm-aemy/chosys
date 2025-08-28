module tb();

wire [31:0] arg0;
wire [31:0] arg2;
wire [31:0] res;
wire [0:0] zero;

assign zero = 0;
assign arg0 = 'b1001110000110110;
assign arg2 = 'b1110010100011010;

top_7 dut (
  (zero),
  (arg0),
  (arg2),
  (res),
  (zero)
);

initial begin
  #10
  if (res !== 'b1000010000010010) begin
    $error("Error!\n");
  end else begin
    $display("Success!\n");
  end
end
endmodule