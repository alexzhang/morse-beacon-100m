`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Constraints for Arty A7
//
// set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }];
// create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK100MHZ }];
// set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ck_io41 }];
// set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { ck_rst }];
//////////////////////////////////////////////////////////////////////////////////

module top(
    input ck_rst, // active low
    input CLK100MHZ,
    output ck_io40,
    output ck_io41
    );

    wire sys_rst_n, sys_rst, sys_clk, morse_clk;
    assign sys_rst = ~sys_rst_n;

    // clk_rf_carr 28.25 MHz
    // clk_morse_tik 7.0625 MHz
    clk_wiz_sys_clk sys_clk_gen(.resetn(ck_rst), .clk_in1(CLK100MHZ), .clk_rf_carr(sys_clk), .clk_morse_tik(morse_clk), .locked(sys_rst_n));

    /* AM Transmitter */
    beacon beacon_inst(.sys_rst(sys_rst), .morse_clk(morse_clk), .data(data));

    reg [21:0] audio_ctr;
    always @(posedge sys_clk)
        audio_ctr = audio_ctr + 1;
    assign ck_io41 = data ? ((audio_ctr[14]) ? sys_clk : 0) : 0;
endmodule
