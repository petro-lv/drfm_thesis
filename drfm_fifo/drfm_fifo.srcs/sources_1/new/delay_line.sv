`timescale 1ns / 1ps


module delay_line #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned MEM_SIZE   = 8,
    parameter int unsigned DELAY      = 1
    )(
    input  logic                    clk,
    input  logic                    rst,
    input  logic  [DATA_WIDTH-1:0]  din,
    output logic  [DATA_WIDTH-1:0]  dout,
    input  logic                    en,
    output logic                    full,
    output logic                    empty,
    output logic                    valid
    );
    
    logic [$clog2(MEM_SIZE)-1:0] count = 0;
    logic [DATA_WIDTH-1:0] mem [MEM_SIZE];
    logic [$clog2(MEM_SIZE)-1:0] wr_ptr, rd_ptr;
    logic can_write, can_read;
    assign can_write = en & !full;
    assign can_read  = en & (count >= DELAY);
    assign rd_ptr = wr_ptr - DELAY + 1;
    assign full = (count == MEM_SIZE);
    assign empty = (count == 0);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            count  <= 0;
            wr_ptr <= 0;
            valid  <= 0;
        end else begin
            valid <= can_read;
            case ({can_write, can_read})
                2'b01: begin
                    dout <= mem[rd_ptr];
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
                end
                default:;      
            endcase
        end
    end
    
endmodule
