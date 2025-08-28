module tb();

reg reset;
wire input_ready;
reg input_valid;
wire output_valid;
reg clk;
wire [31:0] x;
wire [31:0] y;
wire [31:0] res;

assign y = 2637132290;
assign x = 3322124436;

top_1 dut (
  clk,
  reset,
  input_ready,
  input_valid,
  x,
  y,
  output_valid,
  res
);

initial begin
  clk = 1'b0;
  input_valid = 'b0;
  reset = 'b1;
  forever begin
    #10 clk = ~clk;
  end
end

initial begin
  #100
  wait (input_ready === 'b1)
  reset = 'b0;
  #100 input_valid = 'b1;
  #100 input_valid = 'b0;
  wait(output_valid === 'b1)
  #20 
  if (res !== 2) begin
    $error("Error!\n");
  end else begin
    $display("Success!\n");
  $finish();
  end
end
endmodule