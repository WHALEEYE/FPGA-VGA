`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 11:05:32
// Design Name: 
// Module Name: draw_circle
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


module draw_circle(
    input           vga_clk,                  //VGA驱动时钟
    input           sys_rst_n,                //复位信号
    input           ena,                      //使能信号
    
    //串口输入数据
    input           [ 9:0] point_x,
    input           [ 9:0] point_y,
    input           [ 9:0] radius,
    input           [11:0] color,

    input           [ 9:0] pixel_xpos,        //像素点横坐标
    input           [ 9:0] pixel_ypos,        //像素点纵坐标
    //input           [ 9:0] H_DISP,            //分辨率�?��?�行
    //input           [ 9:0] V_DISP,            //分辨率�?��?�列
    output reg      [11:0] pixel_data         //像素点数�?
    );

//**********************************************************
//**                    main code
//**********************************************************
//根据串口指令在指定区域绘制圆

wire [32:0] multi_1;
wire [32:0] multi_2;
wire [32:0] multi_3;

assign multi_1 = (pixel_xpos - point_x) * (pixel_xpos - point_x);
assign multi_2 = (pixel_ypos - point_y) * (pixel_ypos - point_y);
assign multi_3 = radius * radius;

always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data <= 12'd0;
    else begin
        if(ena) begin
            if(multi_1 + multi_2 <= multi_3)
                pixel_data <= color;
            else
                pixel_data <= 12'd0;
        end
    end
end
endmodule