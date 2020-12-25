`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/03 17:12:28
// Design Name: 
// Module Name: vga_driver
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


module vga_driver(
    input         vga_clk,       //VGA驱动时钟
    input         sys_rst_n,     //复位信号
    //VGA接口
    output        vga_hs,        //行同步信号
    output        vga_vs,        //场同步信号
    output [11:0] vga_rgb,       //红绿蓝三原色输出

    input  [11:0] pixel_data,
    output [ 9:0] cnt_h,
    output [ 9:0] cnt_v,
    output        en
);

//parameter define
parameter    H_SYNC    =  10'd96;    
parameter    H_BACK    =  10'd48;
parameter    H_DISP    =  10'd640;
parameter    H_FRONT   =  10'd16;
parameter    H_TOTAL   =  10'd800;

parameter    V_SYNC    =  10'd2;
parameter    V_BACK    =  10'd33;
parameter    V_DISP    =  10'd480;
parameter    V_FRONT   =  10'd10;
parameter    V_TOTAL   =  10'd525;

//reg define
reg    [9:0]  cnt_h;
reg    [9:0]  cnt_v;

//wire define
wire      vga_en;
wire      data_reg;
wire      en;

//main coding
assign en = pixel_xpos >= 0 && pixel_xpos <= 639 && pixel_ypos >= 0 && pixel_ypos <= 479;

//VGA场同步信号
assign vga_hs  = (cnt_h <= H_SYNC-1'b1) ? 1'b0 : 1'b1;
assign vga_vs  = (cnt_v <= V_SYNC-1'b1) ? 1'b0 : 1'b1;

//使能RGB444数据输出
assign vga_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP)) && 
                  ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP))) ? 1'b1 : 1'b0;

//RGB444数据输出
assign vga_rgb = vga_en ? pixel_data : 12'd0;

//请求像素点颜色数据输入
assign data_reg = (((cnt_h >= H_SYNC+H_BACK - 1'b1) && (cnt_h < H_SYNC+H_BACK+H_DISP - 1'b1)) && 
                  ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP))) ? 1'b1 : 1'b0;

//像素点坐标
assign pixel_xpos = data_reg ? (cnt_h - (H_SYNC +H_BACK - 1'b1)) : 10'd0;
assign pixel_ypos = data_reg ? (cnt_v - (V_SYNC +V_BACK - 1'b1)) : 10'd0;

//行计数器对像素时钟计数
always @(posedge vga_clk or negedge sys_rst_n)begin
    if (!sys_rst_n)
        cnt_h <= 10'd0;
    else begin
        if(cnt_h < H_TOTAL - 1'b1)
            cnt_h <= cnt_h + 1'b1;
        else
            cnt_h <= 10'd0;
    end
end

//场计数器对行计数
always @(posedge vga_clk or negedge sys_rst_n)begin
    if (!sys_rst_n)
        cnt_v <= 10'd0;
    else if(cnt_h == H_TOTAL - 1'b1) begin
        if(cnt_v < V_TOTAL - 1'b1)
            cnt_v <= cnt_v + 1'b1;
        else
            cnt_v <= 10'd0;
    end
end


endmodule
