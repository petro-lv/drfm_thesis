`timescale 1ns/1ns

localparam DATA_WIDTH = 32;
localparam DELAY = 2;
localparam MEM_SIZE = 8;

module counter (
    input logic clk,
    input logic rst,
    output logic [DATA_WIDTH-1:0] count
);
    always_ff @(posedge clk) begin
        if (rst) count <= 0;
        else count <= count + 1;
    end
endmodule

module fifo_tb;
  logic clk = 1'b0;
  logic rst;
  logic en;
  logic full, empty;
  logic valid;
  logic  [DATA_WIDTH-1:0]  din, dout;

  delay_line #(
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_SIZE(MEM_SIZE),
    .DELAY(DELAY)
    ) dut (
    .clk(clk),
    .rst(rst),
    .din(din),
    .dout(dout),
    .en(en),
    .full(full),
    .empty(empty),
    .valid(valid)
    );
    
    counter cnt(
        .clk(clk),
        .rst(rst),
        .count(din)
    );
    
  always #5 clk = ~clk; // 100 MHz

  task automatic tick;
    @(posedge clk); #1;
  endtask
 
  task automatic do_reset;
    rst = 1; en=0;
    tick; tick;
    rst = 0; tick;
  endtask
    
  typedef struct packed {
    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;
  } sample_t;

  sample_t q [$];
  int writes, errors;

  initial begin
    errors = 0;
    do_reset;
    writes = 0;
    en=1;
    for (int t = 0; t < MEM_SIZE * 2; t++) begin
      if (valid) begin
        q.push_back('{din: din, dout: dout});
      end
      tick;
      writes++;
    end
    en = 0; tick;
    
  while (q.size() > 0) begin
    sample_t s = q.pop_front();
    assert (s.din - s.dout == DELAY)
      else begin
        $error("din=%0d dout=%0d diff=%0d exp=%0d",
               s.din, s.dout, s.din - s.dout, DELAY);
        errors++;
      end
    end
    if (errors == 0) $display("TEST Passed");
    //drain to empty\
    
    $stop;
  end
endmodule
