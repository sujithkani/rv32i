`timescale 1ns/1ps
module simple_ram #(parameter ADDR_WIDTH=10)(input wire clk, we, input wire [ADDR_WIDTH-1:0] addr, input wire [31:0] din, output reg [31:0] dout);

  reg [31:0] mem [0:(1<<ADDR_WIDTH)-1];

  initial begin
    $readmemh("boot.hex", mem);
  end

  always @(posedge clk) begin
    if(we)
      mem[addr]<=din;
    dout<=mem[addr];
  end

endmodule