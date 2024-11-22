`timescale 1ns / 1ps

module TopModule(
    input clk,
    input ps2c,
    input ps2d,
    output [2:0] TMDSp,
    output [2:0] TMDSn,
    output TMDSp_clock,
    output TMDSn_clock
);

// Signals for keyboard data
wire write_enable;
wire [7:0] ascii_code;  // ASCII code from the keyboard
wire scan_code_ready;

wire [15:0] calculated_address;

// Signals for display data
wire [31:0] dataToSC;    // Data to be written to Screen Memory (from keyboard)
wire [31:0] dispData;    // Display data (to be read from memory by DisplayDriver)
wire [15:0] address;     // Memory address to write/read from
reg [15:0] addr_reg;     // Address register to keep track of the current address
reg cursor;              // Cursor signal



// Address increment logic for writing keyboard data to screen memory
always @(posedge clk) begin
    if (write_enable) begin
        addr_reg <= addr_reg + 1; // Increment address for the next write
        if (addr_reg == 16'd2399) begin
            addr_reg <= 16'd0; // Wrap around if needed
        end
    end
end

assign calculated_address = addr_reg;
assign address = calculated_address; // Use this address for memory and display

// Instantiate the screen memory module
Screen_Memory screenMemory_inst (
    .clock(clk),
    .address(calculated_address),        // Address to write/read from memory
    .displayAddr(calculated_address),   // Pass display address for reading/displaying data
    .byteWrite(1'b1),       // Assuming byteWrite is always enabled for simplicity
    .isWrite(write_enable),   // Write enable from keyboard driver
    .writeData(dataToSC),     // Data to be written to screen memory (from keyboard)
    .displayData(dispData)    // Connect display data to driver
);

// Instantiate the display driver module
DisplayDriver displayDriver_inst (
    .clk(clk),
    .displayData(dispData),
    .TMDSp(TMDSp),
    .TMDSn(TMDSn),
    .TMDSp_clock(TMDSp_clock),
    .TMDSn_clock(TMDSn_clock),
    .system_pointer(calculated_address),        // Renamed input
    .cursor(cursor)
);

// Instantiate the keyboard driver module
keyboardDriver keyboardDriver_inst (
    .ps2c(ps2c),
    .ps2d(ps2d),
    .sysclk(clk),
    .dispData(dataToSC),     // Data to be written to Screen Memory from keyboard
    .write_enable(write_enable),  // Write enable for screen memory
    .scan_code_ready(scan_code_ready),
    .ascii_code(ascii_code)       // ASCII code output from keyboard (to be written to Screen Memory)
);

endmodule // TopModule