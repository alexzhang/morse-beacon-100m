`timescale 1ns / 1ps

module morse_message_rom(
    input [5:0] a,
    output q
    );

    reg [7:0] data;
    assign q = data[a[2:0]];

    always @*
        case (a[5:3])
            3'b000: data = 8'b01110101;
            3'b001: data = 8'b01110001;
            3'b010: data = 8'b01110111;
            3'b011: data = 8'b01011100;
            3'b100: data = 8'b00011101;
            3'b101: data = 8'b01110101;
            3'b110: data = 8'b01110111;
            default: data = 8'b00000000;
        endcase
endmodule

module beacon(
    input sys_rst,
    input morse_clk,
    output data
    );

    reg [26:0] message_ctr;
    always @(posedge morse_clk)
        if (sys_rst) message_ctr <= 0;
        else message_ctr <= message_ctr + 1;

    morse_message_rom morse_message_rom_inst(.a(message_ctr[24:19]), .q(data));
endmodule
