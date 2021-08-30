`timescale 1ns / 1ps

module xorshift_32(
    input clk,
    input rst,
    output out
    );
    /* PSEUDORANDOM INPUT DATA GENERATOR XORSHIFT */
    reg [31:0] xorshift_32_state;

    always @(posedge clk)
        if (rst)
            xorshift_32_state <= 32'b11111111111111111111010000010111;
        else
            xorshift_32_state <= {xorshift_32_state[30:0], xorshift_32_state[31]};

    assign out = xorshift_32_state[0];
endmodule
