`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 02:36:14
// Design Name: 
// Module Name: vga_display_draw
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


module vga_display_draw(
    input             vga_clk   , // 25MHz鏃堕挓
    input             sys_rst_n , // 绯荤粺澶嶄綅

    //涓插彛杈撳叆                       //鍏ㄩ儴鐢诲浘鎵?闇?杈撳叆
    input   [ 9:0]  start_x,
    input   [ 9:0]  start_y,
    input   [ 9:0]  end_x_height,
    input   [ 9:0]  end_y_width,
    input   [ 9:0]  radius,
    input   [ 9:0]  color,
    
    input   [ 2:0]  choice,          //涓插彛缁欏嚭鐢诲浘鎸囦护

    input      [ 9:0] pixel_xpos,
    input      [ 9:0] pixel_ypos,
    output reg [11:0] pixel_data
    );

    //瀹氫箟璇嗗埆杈撳叆淇″彿鐨勪竴浜涘彉閲?
    reg  [ 0:0] ena_point;
    reg  [ 0:0] ena_line;
    reg  [ 0:0] ena_circle;
    reg  [ 0:0] ena_rect;

    //瀹氫箟杩炴帴璁＄畻妯″潡鍜孊RAM鐨勫彉閲?
    wire  [11:0] pixel_data_temp_1;
    wire  [11:0] pixel_data_temp_2;
    wire  [11:0] pixel_data_temp_3;
    wire  [11:0] pixel_data_temp_4;
    reg  [11:0] pixel_data_temp;

    //鏁版嵁閫夋嫨鍣紝瀹炵幇鏁版嵁杈撳叆骞跺垎娴佸埌鍚勪釜妯″潡涓?
    always @(posedge vga_clk or negedge sys_rst_n)
    begin
        if(!sys_rst_n)
            begin
                ena_point  <= 1'b0;
                ena_line   <= 1'b0;
                ena_circle <= 1'b0;
                ena_rect   <= 1'b0;
            end
        else
            begin
                if(choice == 3'b100)
                    begin
                        ena_point  <= 1'b1;
                        ena_line   <= 1'b0;
                        ena_circle <= 1'b0;
                        ena_rect   <= 1'b0;
                    end
                else if(choice == 3'b011)
                    begin
                        ena_point  <= 1'b0;
                        ena_line   <= 1'b1;
                        ena_circle <= 1'b0;
                        ena_rect   <= 1'b0;
                    end
                else if(choice == 3'b001)
                    begin
                        ena_point  <= 1'b0;
                        ena_line   <= 1'b0;
                        ena_circle <= 1'b1;
                        ena_rect   <= 1'b0;
                    end
                else if(choice == 3'b010)
                    begin
                        ena_point  <= 1'b0;
                        ena_line   <= 1'b0;
                        ena_circle <= 1'b0;
                        ena_rect   <= 1'b1;
                    end
            end
    end

    //渚嬪寲鍚勪釜妯″潡
    draw_point u_draw_point(
        .vga_clk    (vga_clk),
        .sys_rst_n  (sys_rst_n),

        .point_x    (start_x),
        .point_y    (start_y),
        .color      (color),

        .ena        (ena_point),

        .pixel_xpos (pixel_xpos),
        .pixel_ypos (pixel_ypos),
        .pixel_data (pixel_data_temp_1)
    );

    draw_line u_draw_line(
        .vga_clk    (vga_clk),
        .sys_rst_n  (sys_rst_n),

        .point_x_start    (start_x),
        .point_y_start    (start_y),
        .point_x_end    (end_x_height),
        .point_y_end    (end_y_width),
        .width          (radius),
        .color          (color),

        .ena        (ena_line),

        .pixel_xpos (pixel_xpos),
        .pixel_ypos (pixel_ypos),
        .pixel_data (pixel_data_temp_2)
    );

    draw_circle u_draw_circle(
        .vga_clk    (vga_clk),
        .sys_rst_n  (sys_rst_n),

        .point_x    (start_x),
        .point_y    (start_y),
        .radius     (radius),
        .color      (color),

        .ena        (ena_circle),

        .pixel_xpos (pixel_xpos),
        .pixel_ypos (pixel_ypos),
        .pixel_data (pixel_data_temp_3)
    );

    draw_rect u_draw_rect(
        .vga_clk    (vga_clk),
        .sys_rst_n  (sys_rst_n),

        .point_x    (start_x),
        .point_y    (start_y),
        .width      (end_y_width),
        .height     (end_x_height),
        .color      (color),

        .ena        (ena_rect),

        .pixel_xpos (pixel_xpos),
        .pixel_ypos (pixel_ypos),
        .pixel_data (pixel_data_temp_4)
    );

    //灏嗘暟鎹绠楀畬鎴愪箣鍚庣粺涓?鍒颁竴鏍圭嚎涓?
    always @(posedge vga_clk or negedge sys_rst_n)
    begin
        if(!sys_rst_n)
            begin
                pixel_data_temp <= 12'b0;
            end
        else
            begin
                if(choice == 3'b100)
                    begin
                        pixel_data_temp <= pixel_data_temp_1;
                    end
                else if(choice == 3'b011)
                    begin
                        pixel_data_temp <= pixel_data_temp_2;
                    end
                else if(choice == 3'b001)
                    begin
                        pixel_data_temp <= pixel_data_temp_3;
                    end
                else if(choice == 3'b010)
                    begin
                        pixel_data_temp <= pixel_data_temp_4;
                    end
            end
    end

    //鏁版嵁鐢辫绠楁ā鍧楄绠楀畬鎴愪互鍚庯紙pixel_data_temp)锛岃緭鍏ram
    //瀹氫箟璁块棶ROM蹇呴』鐨勪竴浜涘彉閲?
	reg  [18:0] R_ram_addr_a; // RAM鐨勫湴鍧?锛堝啓鍏ワ級锛屽繀椤昏姣旀?诲儚绱犵偣涓暟澶э紝鍚﹀垯浼氬嚭鐜皁ut of range
    reg  [18:0] R_ram_addr_b; // RAM鐨勫湴鍧?锛堣鍑猴級锛屽繀椤昏姣旀?诲儚绱犵偣涓暟澶э紝鍚﹀垯浼氬嚭鐜皁ut of range
	wire [11:0] W_ram_data; // RAM涓瓨鍌ㄧ殑鏁版嵁锛屾?诲叡瀛樺偍12浣?
    reg wea;
    
    always @(posedge vga_clk or negedge sys_rst_n)
    begin
        if(!sys_rst_n)
        begin
            wea <= 1'b0;
            R_ram_addr_a <= 19'd0;
        end
        else if(pixel_xpos >= 0 && pixel_xpos <= 639 && pixel_ypos >= 0 && pixel_ypos <= 479)
            begin //?????????????????????
                if(R_ram_addr_a == 307199)
                begin
                    if(pixel_data_temp == 12'b0000_0000_0000)
                        wea   <= 1'b0;
                    else
                        wea   <= 1'b1;
                    R_ram_addr_a <= 19'd0;
                end
                else
                begin
                    if(pixel_data_temp == 12'b0000_0000_0000)
                        wea   <= 1'b0;
                    else
                        wea   <= 1'b1;
                    R_ram_addr_a <= pixel_ypos * 640 + pixel_xpos;
                end
            end
    end

    always @(posedge vga_clk or negedge sys_rst_n)
	begin
		if(!sys_rst_n)
			R_ram_addr_b <= 19'd0;
		else if(pixel_xpos >= 0 && pixel_xpos <= 639 && pixel_ypos >= 0 && pixel_ypos <= 479)
			begin //?????????????????????
                if(R_ram_addr_b == 307199)
					R_ram_addr_b <= 19'd0;
				else
					R_ram_addr_b <= pixel_ypos * 640 + pixel_xpos;
			end
	end

    always @(posedge vga_clk or negedge sys_rst_n)
	begin
	if(!sys_rst_n)
		pixel_data <= 12'b0;
	else if(pixel_xpos >= 0 && pixel_xpos <= 639 && pixel_ypos >= 0 && pixel_ypos <= 479)
		pixel_data <= W_ram_data[11:0];
	else
		pixel_data <= 12'b1;
	end

    blk_mem_gen_0 bram_inst (
        //鍐欏叆鐢ㄧ鍙?
        .clka(vga_clk),    // input wire clka
        .wea(wea),      // input wire [0 : 0] wea
        .addra(R_ram_addr_a),  // input wire [19 : 0] addra
        .dina(pixel_data_temp),    // input wire [11 : 0] dina

        //璇诲嚭鐢ㄧ鍙?
        .clkb(vga_clk),    // input wire clkb
        .addrb(R_ram_addr_b),  // input wire [19 : 0] addrb
        .doutb(W_ram_data)  // output wire [11 : 0] doutb
    ); 

endmodule