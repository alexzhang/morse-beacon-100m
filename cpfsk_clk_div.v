`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/05/2021 09:15:19 PM
// Design Name:
// Module Name: cpfsk_clk_div
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

module counter_modulus_with_roll #(parameter COUNTER_WIDTH = 8, parameter COUNTER_MAX = 255) (
    input clk,
    input rst,
    output reg [COUNTER_WIDTH-1:0] count,
    output roll
    );

    assign roll = (count == COUNTER_MAX - 1);
    always @(posedge clk)
        if (rst || roll)
            count <= {COUNTER_WIDTH{1'b0}};
        else
            count <= count + 1'b1;
endmodule

module cpfsk_clk_div(
    input clk,
    input rst,
    output reg clk_dds,
    output reg clk_baud
    );

    wire should_toggle_dds, should_toggle_baud;

    always @(posedge clk)
        if (rst)
            clk_dds <= 0;
        else if (should_toggle_dds)
            clk_dds <= ~clk_dds;

    always @(posedge clk)
        if (rst)
            clk_baud <= 0;
        else if (should_toggle_baud)
            clk_baud <= ~clk_baud;

    /* Divide by 500 to get the frequency for DDS 13200 Hz */
    counter_modulus_with_roll #(.COUNTER_WIDTH(8), .COUNTER_MAX(500/2)) div_by_500_dds (.clk(clk), .rst(rst), .roll(should_toggle_dds));
    /* Divide by 5500 to get clock for data in baud rate 1200 Hz */
    counter_modulus_with_roll #(.COUNTER_WIDTH(12), .COUNTER_MAX(5500/2)) div_by_5500_dds (.clk(clk), .rst(rst), .roll(should_toggle_baud));
endmodule
