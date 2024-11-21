`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Keyboard Driver Module
//////////////////////////////////////////////////////////////////////////////////

module keyboardDriver(
    input ps2c, ps2d,
    input sysclk,
    output reg [31:0] dispData, // Data to be sent to screen memory
    output reg write_enable,      // Signal to enable writing to screen memory
    output scan_code_ready,
    output [7:0] ascii_code
);

    // Internal signals
    wire scan_done_tick;
    wire [7:0] scan_out;
    parameter lowercase = 0;
    parameter break_state = 1;
    parameter BREAK = 8'hf0; // Key released

    wire [2:0] next_state;
    reg [2:0] current_state;
    reg sample;

    // Initialize sampling
    initial begin
        sample <= 1'b1;
        current_state <= lowercase;
        write_enable <= 1'b0; // Initialize write enable to low
    end

    // PS/2 Receiver instance
    ps2_rx ps2_rx_unit (
        .clk(sysclk),
        .reset(1'b0),
        .rx_en(1'b1),
        .ps2d(ps2d),
        .ps2c(ps2c),
        .rx_done_tick(scan_done_tick),
        .rx_data(scan_out)
    );

    // State machine for keyboard scanning
    always @(posedge scan_done_tick) begin
        current_state <= next_state;
    end

    assign next_state = (current_state == lowercase && scan_out == BREAK) ? break_state : lowercase;
    assign scan_code_ready = (current_state == break_state) ? 1'b1 : 1'b0;

    // Convert scan code to ASCII
    scanToAscii scanToAscii_unit (
        .letter_case(1'b0),
        .scan_code(scan_out),
        .ascii_code(ascii_code)
    );

    // Handling the ASCII code ready to write to display
    always @(posedge sysclk) begin
        if (scan_code_ready) begin
            dispData <= {24'b0, ascii_code}; // Store the ASCII code (8 bits) in a 32-bit word
            write_enable <= 1'b1; // Signal to enable writing to memory
        end else begin
            write_enable <= 1'b0; // Disable write when no key is pressed
        end
    end
endmodule
