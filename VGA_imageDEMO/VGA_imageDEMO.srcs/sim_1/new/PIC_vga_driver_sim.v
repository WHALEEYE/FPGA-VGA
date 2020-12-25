`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/22 20:51:46
// Design Name: 
// Module Name: PIC_vga_driver_sim
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


module PIC_vga_driver_sim();
    // Inputs
	reg I_clk;
	reg I_rst_n;

	// Outputs
	wire [3:0] O_red;
	wire [3:0] O_green;
	wire [3:0] O_blue;
	wire O_hs;
	wire O_vs;

	// Instantiate the Unit Under Test (UUT)
	PIC_vga_driver u(
		.I_rst_n(I_rst_n),
		.I_clk(I_clk), 
		.O_red(O_red), 
		.O_green(O_green), 
		.O_blue(O_blue), 
		.O_hs(O_hs), 
		.O_vs(O_vs)
	);

	initial begin
		I_rst_n=1; #30;
		I_rst_n=0; #30;
		I_rst_n=1; #30;
		I_rst_n=0; #30;
		I_rst_n=1; #30;
		I_rst_n=0; #30;
		I_rst_n=1; #30;		
	end

	always begin
		I_clk =0 ; #2;
		I_clk =1 ; #2;
    end
endmodule
