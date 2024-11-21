//`timescale 1ns / 1ps

//module TopModule(
//    input clk,
//    input ps2c,
//    input ps2d,
//    output [2:0] TMDSp,
//    output [2:0] TMDSn,
//    output TMDSp_clock,
//    output TMDSn_clock
//);

//// Signals for display data and write enable
//wire [31:0] dispData;
//wire write_enable;
//wire [15:0] address;
//reg [15:0] addr_reg; // Address register to keep track of the current address

//// Increment address logic
//always @(posedge clk) begin
//    if (write_enable) begin
//        addr_reg <= addr_reg + 1; // Increment address for the next write
//        if (addr_reg == 16'd2399) begin
//            addr_reg <= 16'd0; // Wrap around if needed
//        end
//    end
//end

//assign address = addr_reg; // Use this address for memory and display

//// Instantiate the display driver module
//DisplayDriver displayDriver_inst (
//    .clk(clk),
//    .displayData(dispData), // Connect displayData from memory to the display driver
//    .TMDSp(TMDSp),
//    .TMDSn(TMDSn),
//    .TMDSp_clock(TMDSp_clock),
//    .TMDSn_clock(TMDSn_clock),
//    .pointer(address) // Use address for display memory pointer
//);

//// Instantiate the keyboard driver module
//keyboardDriver keyboardDriver_inst (
//    .ps2c(ps2c),
//    .ps2d(ps2d),
//    .sysclk(clk),
//    .dispData(dispData),
//    .write_enable(write_enable),
//    .scan_code_ready(scan_code_ready),
//    .ascii_code(ascii_code)
//);

//// Instantiate the screen memory module
//Screen_Memory screenMemory_inst (
//    .clock(clk),
//    .address(address), // Connect the address to the screen memory
//    .byteWrite(1'b0), // Assuming full word write for this example
//    .isWrite(write_enable), // Write enable from keyboard driver
//    .writeData(dispData), // Data from keyboard driver to write to memory
//    .displayData(displayData) // Connect display data to driver
//);

//endmodule // TopModule
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

// Signals for display data
wire [31:0] dispData;
wire [15:0] address;
reg [15:0] addr_reg; // Address register to keep track of the current address

// Increment address logic
always @(posedge clk) begin
    if (write_enable) begin
        addr_reg <= addr_reg + 1; // Increment address for the next write
        if (addr_reg == 16'd2399) begin
            addr_reg <= 16'd0; // Wrap around if needed
        end
    end
end

assign address = addr_reg; // Use this address for memory and display

// Bitmap output for ASCII to pixel conversion
wire [31:0] bitmap_out;

// Instantiate the Bitmap module
Bitmap bitmap_inst (
    .ascii_code(ascii_code),
    .bitmap_out(bitmap_out)
);

// Instantiate the screen memory module
Screen_Memory screenMemory_inst (
    .clock(clk),
    .address(address),       // Address to write/read from memory
    .byteWrite(1'b0),        // Full word write
    .isWrite(write_enable),  // Write enable from keyboard driver
    .writeData(bitmap_out),  // Write bitmap data from Bitmap module
    .displayData(dispData)   // Connect display data to driver
);

// Instantiate the display driver module
DisplayDriver displayDriver_inst (
    .clk(clk),
    .displayData(dispData), // Connect displayData from memory to the display driver
    .TMDSp(TMDSp),
    .TMDSn(TMDSn),
    .TMDSp_clock(TMDSp_clock),
    .TMDSn_clock(TMDSn_clock),
    .pointer(address)       // Use address for display memory pointer
);

// Instantiate the keyboard driver module
keyboardDriver keyboardDriver_inst (
    .ps2c(ps2c),
    .ps2d(ps2d),
    .sysclk(clk),
    .write_enable(write_enable),  // Write enable for screen memory
    .scan_code_ready(scan_code_ready), 
    .ascii_code(ascii_code)       // ASCII output to Bitmap module
);

endmodule // TopModule
