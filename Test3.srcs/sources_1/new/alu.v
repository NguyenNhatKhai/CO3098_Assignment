`timescale 1ns / 1ns

module alu(clk, rst_n, operand_0, operand_1, control, result, zero_flag, invalid_flag, overflow_flag);
  input clk;
  input rst_n;
  input [7:0] operand_0;
  input [7:0] operand_1;
  input [3:0] control;
  output reg [7:0] result;
  output zero_flag;
  output reg invalid_flag;
  output overflow_flag;
  
  reg [7:0] operand_0_sync;
  reg [7:0] operand_1_sync;
  reg [3:0] control_sync;
  
  always @(posedge clk) begin
    if (rst_n == 1'b0) begin
      operand_0_sync <= 8'b0;
      operand_1_sync <= 8'b0;
      control_sync <= 4'b0;
    end
    else begin
      operand_0_sync <= operand_0;
      operand_1_sync <= operand_1;
      control_sync <= control;
    end
  end
  
  always @(control_sync) begin
    case (control_sync)
      4'b0000, 4'b1100, 4'b0001, 4'b1101, 4'b0010, 4'b0011, 4'b0111: begin
        invalid_flag = 1'b0;
      end
      default: begin
        invalid_flag = 1'b1;
      end
    endcase
  end
  
  reg [7:0] operand_0_formal;
  reg [7:0] operand_1_formal;
  
  always @(operand_0_sync, operand_1_sync, control_sync) begin
    if (control_sync[3] == 1'b1) begin
      operand_0_formal = ~ operand_0_sync;
    end
    else begin
      operand_0_formal = operand_0_sync;
    end
    if (control_sync[2] == 1'b1) begin
      operand_1_formal = ~ operand_1_sync;
    end
    else begin
      operand_1_formal = operand_1_sync;
    end
  end
  
  wire [7:0] and_result;
  wire [7:0] or_result;
  wire [7:0] xor_result;
  wire [7:0] add_result;
  assign and_result = operand_0_formal & operand_1_formal;
  assign or_result = operand_0_formal | operand_1_formal;
  assign xor_result = operand_0_formal ^ operand_1_formal;
  assign {overflow_flag, add_result} = operand_0_formal + operand_1_formal + control_sync[2];
  
  always @(add_result, and_result, or_result, xor_result, control_sync, invalid_flag) begin
    if (invalid_flag == 1'b1) begin
      result = 8'b0;
    end
    else begin
      case (control_sync[1:0])
        2'b00: begin
          result = and_result;
        end
        2'b01: begin
          result = or_result;
        end
        2'b10: begin
          result = xor_result;
        end
        2'b11: begin
          result = add_result;
        end
        default: begin
          result = 8'b0;
        end
      endcase
    end
  end
  
  assign zero_flag = result == 8'b0;
endmodule
