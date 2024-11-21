`timescale 1ns / 1ps

module Bitmap (
    input [7:0] ascii_code,          // ASCII code from the keyboard
    output reg [31:0] bitmap_out     // 32-bit row of the bitmap
);

    // ROM to store 32x32 bitmaps for each ASCII character
    reg [31:0] font_rom [0:127][0:31]; // 128 ASCII codes, each with 32 rows (32 bits per row)

    // Initialize ROM with a font table (this example includes basic A, B, and C)
    initial begin
        // ASCII 'A' (65) bitmap
        font_rom[65][0]  = 32'b00000000011111000000000000000000;
        font_rom[65][1]  = 32'b00000000100000100000000000000000;
        font_rom[65][2]  = 32'b00000001000000010000000000000000;
        font_rom[65][3]  = 32'b00000010000000001000000000000000;
        font_rom[65][4]  = 32'b00000010000000001000000000000000;
        font_rom[65][5]  = 32'b00000011111111111000000000000000;
        font_rom[65][6]  = 32'b00000100000000000100000000000000;
        font_rom[65][7]  = 32'b00001000000000000010000000000000;
        // ... (Add remaining rows for 'A')
        
        // ASCII 'B' (66) bitmap
        font_rom[66][0]  = 32'b00000011111111110000000000000000;
        font_rom[66][1]  = 32'b00000010000000001000000000000000;
        font_rom[66][2]  = 32'b00000010000000001000000000000000;
        font_rom[66][3]  = 32'b00000011111111110000000000000000;
        font_rom[66][4]  = 32'b00000010000000001000000000000000;
        font_rom[66][5]  = 32'b00000010000000001000000000000000;
        font_rom[66][6]  = 32'b00000011111111110000000000000000;
        font_rom[66][7]  = 32'b00000000000000000000000000000000;
        // ... (Add remaining rows for 'B')

end 
endmodule
