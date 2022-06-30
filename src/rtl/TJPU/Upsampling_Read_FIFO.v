`timescale 1ns / 1ps


module Upsampling_Read_FIFO#(parameter
        WIDTH       = 128,
        ADDR_BITS   = 10
    )(
     input clk,
     input rst,
     input [WIDTH-1:0] din,
     input wr_en,
 
     input rd_en,
     output [WIDTH-1:0] dout,
   
     input [ADDR_BITS:0] M_count,  //back
     output reg M_Ready,
     input [ADDR_BITS:0] S_count,   //front
     output reg S_Ready
);  

wire full;
wire [7:0]data_count;
upsampling_fifo_read fifo_read (
  .clk(clk),                  // input wire clk
  .srst(rst),                // input wire srst
  .din(din),                  // input wire [127 : 0] din
  .wr_en(wr_en),              // input wire wr_en
  .rd_en(rd_en),              // input wire rd_en
  .dout(dout),                // output wire [127 : 0] dout
  .full(full),                // output wire full
  .empty(),              // output wire empty
  .data_count(data_count) // output wire [10 : 0] data_count

);

always@(posedge clk) begin
    if(rst) begin
       M_Ready <= 1'b0;
    end
    else if(data_count>=M_count) 
        M_Ready <= 1'b1;
    else 
       M_Ready <= 1'b0;
end

always@(posedge clk) begin
    if(rst) begin
       S_Ready <= 1'b1;
    end
    else if(data_count<125) 
        S_Ready <= 1'b1;
    else 
       S_Ready <= 1'b0;
end
 
endmodule

