`timescale 1ns/1ns
module ARM_TOP(
    input clk,
    input ps2c,
    input ps2d,
    output [2:0] TMDSp,
    output [2:0] TMDSn,
    output TMDSp_clock,
    output TMDSn_clock
);
    // Clock and reset signals
    reg sram_clk = 1;
    reg rst;
    reg sram_rst;
    reg isForwardingActive;
    wire SRAM_WE_N;
    wire [16:0] SRAM_ADDR;
    wire [63:0] SRAM_DQ;
    
    // Signals for keyboard data
    wire write_enable;
    wire [7:0] ascii_code;  // ASCII code from the keyboard
    wire scan_code_ready;
    
    // Clock generation for display
    reg [1:0] clk_div_counter = 0;
    reg display_clk_reg = 0;
    wire display_clk;

    // Clock buffer to ensure proper clock input
    BUFG display_clk_buffer (
        .I(display_clk_reg),
        .O(display_clk)
    );

    // Clock division logic
    always @(posedge clk) begin
        clk_div_counter <= clk_div_counter + 1;
        if (clk_div_counter == 2'b01) begin
            display_clk_reg <= ~display_clk_reg;
        end
    end

    // Signals for display data
    reg [15:0] addr_reg; // Address register to keep track of the current address
    wire [31:0] display_address;
    wire [31:0] display_dataOut;

    // Display Driver instantiation with buffered clock
    DisplayDriver dispDriver (
        .clk(display_clk),     // Use the buffered display clock
        .displayData(display_dataOut),
        .TMDSp(TMDSp),
        .TMDSn(TMDSn),
        .pointer(display_address),
        .TMDSp_clock(TMDSp_clock),
        .TMDSn_clock(TMDSn_clock)
    );
    
    // Keyboard driver section
    parameter lowercase = 0;
    parameter state_break = 1;
    parameter BREAK = 8'hf0; //key released
    wire scan_done_tick;
    wire [7:0] scan_out;
    reg [7:0] key_reg;
        
    wire [2:0] next_state;
    reg [2:0] current_state;
    reg sample;
    
    initial begin
        sample <= 1'b1;
    end
    
    ps2_rx ps2_rx_unit (
        .clk(clk), 
        .reset(1'b0), 
        .rx_en(1'b1), 
        .ps2d(ps2d), 
        .ps2c(ps2c), 
        .rx_done_tick(scan_done_tick), 
        .rx_data(scan_out)
    );
    
    initial begin
        current_state = lowercase;
    end
    
    always @(posedge scan_done_tick) begin
        current_state <= next_state;
    end
    
    assign next_state = (current_state == lowercase && scan_out == BREAK) ? state_break : lowercase;
    assign scan_code_ready = (current_state == state_break) ? 1'b1 : 1'b0;
    
    scanToAscii scanToAscii_unit (
        .letter_case(1'b0), 
        .scan_code(scan_out), 
        .ascii_code(ascii_code)
    );
    
    always @(negedge scan_code_ready) begin
        key_reg <= ascii_code;
        sample <= ~sample;
    end  
     
    // ARM CPU instantiation
    ARM CPU(
        .clk(clk),
        .rst(rst),
        .isForwardingActive(isForwardingActive),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
    );
    
    // SRAM instantiation
    SRAM sram (
        .clk(clk),
        .rst(sram_rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ),
        .displayAddr(display_address),
        .displayData(display_dataOut),
        .sample(sample),
        .key_reg(key_reg)
    );
    
    // SRAM Clock generation
    always #20 sram_clk = ~sram_clk;
    
    // Initial block for reset sequence
    initial begin
        rst = 1;
        sram_rst = 1;
        isForwardingActive = 1;
        # (30);
        rst = 0;
        sram_rst = 0;
        # (15000);
        $stop;
    end
    
endmodule