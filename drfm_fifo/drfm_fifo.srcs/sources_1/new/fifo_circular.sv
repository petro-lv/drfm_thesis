`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2026 03:21:29
// Design Name: 
// Module Name: fifo_circular
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_circular #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned MEM_SIZE   = 8
    )(
    input  logic                    clk,
    input  logic                    rst,
    input  logic  [DATA_WIDTH-1:0]  din,
    output logic  [DATA_WIDTH-1:0]  dout,
    input  logic                    wr_enable,
    input  logic                    rd_enable,
    output logic                    full,
    output logic                    empty,
    output logic                    valid
    );
    
    logic [$clog2(MEM_SIZE)-1:0] count = 0;
    logic [DATA_WIDTH-1:0] mem [MEM_SIZE];
    logic [$clog2(MEM_SIZE)-1:0] wr_ptr, rd_ptr;
    logic can_write, can_read;
    assign can_write = wr_enable & !full;
    assign can_read = rd_enable & !empty;
    assign full = (count == MEM_SIZE);
    assign empty = (count == 0);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            case ({can_write, can_read})
                2'b01: begin
                    dout <= mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                    count <= count - 1;
                end
                2'b10: begin
                    mem[wr_ptr] <= din;
                    wr_ptr <= wr_ptr + 1;
                    count <= count + 1;
                end
                2'b11: begin
                    mem[wr_ptr] <= din;
                    dout <= mem[rd_ptr];
                    wr_ptr <= wr_ptr + 1;
                    rd_ptr <= rd_ptr + 1;
                end
                default:
                    ;
            endcase
        end
    end
    
endmodule
