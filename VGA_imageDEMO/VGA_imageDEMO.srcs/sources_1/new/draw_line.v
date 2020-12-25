`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 11:03:51
// Design Name: 
// Module Name: draw_line
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


module draw_line(
    input           vga_clk,                  //VGA驱动时钟
    input           sys_rst_n,                //复位信号
    input           ena,                      //使能信号

    //串口输入信息
    input           [ 9:0] point_x_start,
    input           [ 9:0] point_y_start,
    input           [ 9:0] point_x_end,
    input           [ 9:0] point_y_end,
    input           [ 9:0] width,
    input           [11:0] color,

    
    input           [ 9:0] pixel_xpos,        //像素点横坐标
    input           [ 9:0] pixel_ypos,        //像素点纵坐标
    //input           [ 9:0] H_DISP,            //分辨率�?��?�行
    //input           [ 9:0] V_DISP,            //分辨率�?��?�列
    output reg      [11:0] pixel_data         //像素点数�?
    );

//wire define
wire [32:0] a1;
wire [32:0] a2;
wire [32:0] a;
wire [32:0] b;

//**********************************************************
//**                    main code
//**********************************************************

//计算正确的对照斜�?
assign a1 = ( pixel_xpos - point_x_start ) * point_y_end;
assign a2 = ( pixel_xpos - point_x_end   ) * point_y_start;
assign a  = a1 - a2;
assign b  = ( point_x_end - point_x_start) * pixel_ypos;

//根据串口指令在指定区域绘制线
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data <= 12'd0;
    else begin
        if(ena) begin
            if(a <= b && b <= a + width)
                pixel_data <= color;
            else
                pixel_data <= 12'd0;
        end
    end
end
endmodule
