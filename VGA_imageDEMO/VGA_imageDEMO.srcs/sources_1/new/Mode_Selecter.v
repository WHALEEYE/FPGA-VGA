`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/23 01:08:37
// Design Name:
// Module Name: Mode_Selector
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


module Mode_Selector(
           input rst, clk, din,
           output reg[9: 0]startx,
           output reg[9: 0]starty,
           output reg[9: 0]exh,
           output reg[9: 0]eyw,
           output reg[9: 0]radwi,
           output reg[11: 0]color,
           output reg[2: 0]choice
       );
parameter period = 133;
wire [7: 0] dout;
wire dout_vld;
wire[9: 0]tstartx;
wire[9: 0]tstarty;
wire[9: 0]texh;
wire[9: 0]teyw;
wire[9: 0]tradwi;
wire[11: 0]tcolor;
wire[2: 0]tchoice;
wire ena;
Serial_Interface #(period) SI(rst, clk, din, dout, dout_vld);
Command_Parser CmdPsr(rst, dout, dout_vld, tstartx, tstarty, texh, teyw, tradwi, tcolor, ena, tchoice);

always@(posedge ena or negedge rst)
begin
    if (!rst)
    begin
        startx <= 10'b0000000000;
        starty <= 10'b0000000000;
        exh <= 10'b0000000000;
        eyw <= 10'b0000000000;
        radwi <= 10'b0000000000;
        color <= 12'b000000000000;
        choice <= 3'b000;
    end
    else
    begin
        startx <= tstartx;
        starty <= tstarty;
        exh <= texh;
        eyw <= teyw;
        radwi <= tradwi;
        color <= tcolor;
        choice <= tchoice;
    end
end
endmodule
