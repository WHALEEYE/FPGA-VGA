`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2020/12/23 01:06:53
// Design Name:
// Module Name: Command_Parser
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


module Command_Parser(input rst,
                      input[7: 0] dout,
                      input dout_vld,
                      output reg[9: 0]startx,
                      output reg[9: 0]starty,
                      output reg[9: 0]exh,
                      output reg[9: 0]eyw,
                      output reg[9: 0]radwi,
                      output reg[11: 0]color,
                      output reg ena,
                      output reg[2: 0]choice
                     );
reg[31: 0] cmd_cnt;

always @(posedge dout_vld or negedge rst)
begin
    if (!rst)
    begin
        cmd_cnt <= 0;
        ena <= 1'b0;
    end
    else if (cmd_cnt == 69)
    begin
        cmd_cnt <= 0;
        ena <= 1'b1;
    end
    else
    begin
        cmd_cnt <= cmd_cnt + 1;
        ena <= 1'b0;
    end
end

always @(posedge dout_vld or negedge rst)
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
        case (cmd_cnt)
            0:
            case (dout)
                8'b01100011:
                    choice <= 3'b001;
                8'b01110010:
                    choice <= 3'b010;
                8'b01101100:
                    choice <= 3'b011;
                8'b01110000:
                    choice <= 3'b100;
            endcase
            2, 3, 4, 5, 6, 7, 8, 9, 10, 11:
                startx[11 - cmd_cnt] <= dout[0];
            13, 14, 15, 16, 17, 18, 19, 20, 21, 22:
                starty[22 - cmd_cnt] <= dout[0];
            24, 25, 26, 27, 28, 29, 30, 31, 32, 33:
                exh[33 - cmd_cnt] <= dout[0];
            35, 36, 37, 38, 39, 40, 41, 42, 43, 44:
                eyw[44 - cmd_cnt] <= dout[0];
            46, 47, 48, 49, 50, 51, 52, 53, 54, 55:
                radwi[55 - cmd_cnt] <= dout[0];
            57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68:
                color[68 - cmd_cnt] <= dout[0];
        endcase
    end
end

endmodule
