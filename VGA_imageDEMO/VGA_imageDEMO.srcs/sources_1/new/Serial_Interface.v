`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/19 17:34:39
// Design Name:
// Module Name: Serial_Interface
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

module Serial_Interface(
           input rst, clk, din,
           output reg[7: 0]dout,
           output reg dout_vld
       );

parameter period = 133;                 //750000 baud rate
reg[31: 0]cnt0;                         //The counter to count the original clk posedges
reg[3: 0]cnt1;                          //The counter to count the bits received in one frame
wire add_cnt0, end_cnt0, add_cnt1, end_cnt1;

reg rx0, rx1, rx2;
wire rx_en;
reg flag_add;

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        rx0 <= 1'b1;
        rx1 <= 1'b1;
        rx2 <= 1'b1;
    end
    else
    begin
        rx0 <= din;
        rx1 <= rx0;
        rx2 <= rx1;
    end
end

assign rx_en = rx2 & ~rx1;              //If a negedge detected, begin transporting

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        cnt0 <= 0;
    end
    else if (add_cnt0)
    begin
        if (end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign add_cnt0 = flag_add;
assign end_cnt0 = (add_cnt0 && (cnt0 == (period - 1)));

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        cnt1 <= 0;
    end
    else if (add_cnt1)
    begin
        if (end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign add_cnt1 = end_cnt0;
assign end_cnt1 = (add_cnt1 && (cnt1 == 8));    //If already received 8 bits and meets the time to add, means the process is done, don't need to receive the stop signal

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        flag_add <= 1'b0;
    end
    else if (rx_en)
    begin
        flag_add <= 1'b1;   //Once received the signal of begin transporting, set flag_add to 1
    end
    else if (end_cnt1)
    begin
        flag_add <= 1'b0;   //Once 8 bits already received, stop the original clk counter
    end
end

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        dout <= 8'd0;
    end
    else if ((add_cnt0 && (cnt0 == ((period >> 1) - 1))) && (cnt1 != 0))		//Receive the bit information at the middle of one bit (more stable), from lower digits to higher digits
    begin
        dout[cnt1 - 1] <= rx2 ;                                                 //Receive the bit information
    end
end


//Detect if the transport is done
always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        dout_vld <= 1'b0;
    end
    else if (end_cnt1)
    begin
        dout_vld <= 1'b1;           //When the transport is done, set dout_vld to 1
    end
    else
    begin
        dout_vld <= 1'b0;
    end
end
endmodule
