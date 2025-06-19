`timescale 1ns/1ps
module tb;
  reg clk=0, rst=1;
  integer i;
  rv32i_top dut(.clk(clk),.rst(rst));
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("rv32i.vcd");
    $dumpvars(0,dut);
    #20 rst=0;
    //Allow enough time
    #1000;
    //Display full data memory
    $display("====== DATA MEMORY DUMP ======");
    for (i=0; i<64; i=i+1) begin
      $display("data_mem[%2d]    0x%08h",i,dut.data_mem.mem[i]);
    end
    #1 $finish;
  end
endmodule
