`timescale 1ns / 1ns

module alu_testbench();
  reg clk;
  reg rst_n;
  reg [7:0] operand_0;
  reg [7:0] operand_1;
  reg [3:0] control;
  wire [7:0] result;
  wire zero_flag;
  wire invalid_flag;
  wire overflow_flag;
  
  alu uut(clk, rst_n, operand_0, operand_1, control, result, zero_flag, invalid_flag, overflow_flag);
  
  always #5 clk = ~ clk;
  
  initial begin
    clk <= #0 1'b0;
    rst_n <= #0 1'b1;
    rst_n <= #13 1'b0;
    rst_n <= #17 1'b1;
    control <= #56 4'b0111;
    operand_0 <= #84 8'b10110110;
    operand_1 <= #84 8'b01101010;
    #100 $finish;
  end
endmodule
