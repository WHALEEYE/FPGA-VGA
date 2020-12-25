`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 02:34:10
// Design Name: 
// Module Name: vga_draw
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


module vga_draw(
    input           sys_clk,         //系统时钟
    input           sys_rst_n,       //复位信号
    input           din,
    //串口输入                       //全部画图�??�??输入
    //VGA接口
    output          vga_hs,          //行同步信�??
    output          vga_vs,          //场同步信�??
    output  [11:0]  vga_rgb          //红绿蓝三原色输出
    );


//wire define
wire         vga_clk_w;       //PLL分频得到25Mhz时钟
wire         locked_w;        //PLL输出稳定信号
wire         rst_n_w;         //内部复位信号
wire [11:0]  pixel_data_w;    //像素点数
wire [ 9:0]  pixel_xpos_w;    //像素点横坐标
wire [ 9:0]  pixel_ypos_w;    //像素点纵坐标

//串口输入                       //全部画图�??�??输入
wire [ 9:0]  start_x;
wire [ 9:0]  start_y;
wire [ 9:0]  end_x_height;
wire [ 9:0]  end_y_width;
wire [ 9:0]  radius;
wire [12:0]  color;

wire [ 2:0]  choice;         //串口给出画图指令

Mode_Selector MSr(rst_n_w, sys_clk, din, start_x, start_y, end_x_height, end_y_width, radius, color, choice);

//待PLL输出稳定之后，停止复�???
assign rst_n_w = sys_rst_n && locked_w;

//时钟分频模块
vga_pll u_vag_pll(             
    .clk_in1      (sys_clk), 
    .reset        (~sys_rst_n),

    .clk_out1     (vga_clk_w),    //VGA时钟 25M
    .locked       (locked_w)
    );


vga_driver u_vga_driver(
    .vga_clk     (vga_clk_w),
    .sys_rst_n   (rst_n_w),

    .vga_hs      (vga_hs),
    .vga_vs      (vga_vs),
    .vga_rgb     (vga_rgb),

    .pixel_data  (pixel_data_w),
    .pixel_xpos  (pixel_xpos_w),
    .pixel_ypos  (pixel_ypos_w)
);

vga_display_draw u_vga_display_draw(
    .vga_clk     (vga_clk_w),
    .sys_rst_n   (rst_n_w),

    .start_x     (start_x),
    .start_y     (start_y),
    .end_x_height(end_x_height),
    .end_y_width (end_y_width),
    .radius      (radius),
    .color       (color),
    .choice      (choice),

    .pixel_xpos  (pixel_xpos_w),
    .pixel_ypos  (pixel_ypos_w),
    .pixel_data  (pixel_data_w)
);

endmodule
