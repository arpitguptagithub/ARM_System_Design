module keyboard_driver(
    input ps2c, ps2d,
    input sysclk,
    output reg [15:0] mem_addr,   // Memory address for ASCII display
    output reg isWrite,           // Write enable for `Screen_Memory`
    output reg [31:0] writeData   // ASCII code to write
);

    wire scan_code_ready;
    wire [7:0] ascii_code;
    reg key_reg;
    wire scan_done_tick;
    wire [7:0] scan_out;

    ps2_rx ps2_rx_unit (.clk(sysclk), .reset(1'b0), .rx_en(1'b1), .ps2d(ps2d), .ps2c(ps2c), .rx_done_tick(scan_done_tick), .rx_data(scan_out));
    scanToAscii scanToAscii_unit (.letter_case(1'b0), .scan_code(scan_out), .ascii_code(ascii_code));

    initial begin
        mem_addr <= 16'd0;      // Start writing at address 0
        isWrite <= 1'b0;        // Disable write initially
    end

    always @(posedge scan_code_ready) begin
        writeData <= {24'd0, ascii_code}; // ASCII to 32-bit data
        isWrite <= 1'b1;                  // Enable write to `Screen_Memory`
        mem_addr <= mem_addr + 16'd1;     // Increment address for next char
    end

    always @(negedge scan_code_ready) begin
        isWrite <= 1'b0; // Disable write once data is written
    end
endmodule
