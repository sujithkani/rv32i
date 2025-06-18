`timescale 1ns/1ps
module tb;
  reg clk=0, rst=1;

  rv32i_top dut(.clk(clk),.rst(rst));
  always #5 clk=~clk;
  
  initial begin
    $dumpfile("rv32i.vcd");
    $dumpvars(0,dut);
    #20 rst=0;
    // Allow enough time
    #1000;
    // Check memory content at address 0 (result of sw x3, 0(x0))
    $display("MEM[0]=%h",dut.data_mem.mem[0]);
    #1 $finish;
  end
endmodule
