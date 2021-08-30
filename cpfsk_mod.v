`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/02/2021 04:26:23 PM
// Design Name:
// Module Name: cpfsk_mod
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

module sin_rom (
    input wire clk,
    input wire [7:0] a,
    output reg [7:0] d
    );

    reg [7:0] cpfsk_rom [0:131];
    initial $readmemh("sin132.hex", cpfsk_rom, 0); // sine wave, 8-bits, 132 samples

    always @(posedge clk) begin
        d <= cpfsk_rom[a];
    end
endmodule

module cpfsk_mod(
    input clk_in,
    input sys_rst,
    output clk_out,
    output cpfsk_rst,
    input data,
    output [7:0] audio_out
    );

    wire clk_dds;
    cpfsk_clk_div cpfsk_clk_gen(.rst(sys_rst), .clk(clk_in), .clk_dds(clk_dds), .clk_baud(clk_out));

    reg [31:0] cpfsk_rst_reg;
    assign cpfsk_rst = ~cpfsk_rst_reg[0];
    always @(negedge clk_dds or posedge sys_rst)
        if (sys_rst)
            cpfsk_rst_reg <= 32'b0;
        else
            cpfsk_rst_reg <= {1'b1, cpfsk_rst_reg[31:1]};

    reg [7:0] rom_iter;
    always @(posedge clk_dds)
        if (cpfsk_rst) rom_iter <= 0;
        else rom_iter <= (rom_iter + ((data) ? 12 : 22)) % 132;

    sin_rom dds_rom(.clk(clk_in), .a(rom_iter), .d(audio_out));
endmodule
