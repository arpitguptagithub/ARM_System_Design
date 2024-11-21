`timescale 1ns / 1ps


module DisplayDriver(
    input clk,
    input [31:0] displayData,
    
    output [2:0] TMDSp,
    output [2:0] TMDSn,
    output TMDSp_clock,
    output TMDSn_clock,
//    output [31:0] pointer,
    input wire [31:0] pointer // Change to input wir
);

// Clock divider 125 MHz to 25 MHz pixel clock, and multiplier 125 MHz to 250 MHz
wire MMCM_pix_clock, pixclk;
wire clk_TMDS, DCM_TMDS_CLKFX;
wire clkfb_in, clkfb_out;

MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(6.0),
    .CLKFBOUT_PHASE(0.0),
    .CLKIN1_PERIOD(8.0),
    .CLKOUT1_DIVIDE(30),  // 125*6/30 = 25 MHz
    .CLKOUT2_DIVIDE(3),   // 125*6/3  = 250 MHz
    .CLKOUT3_DIVIDE(1),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT0_DIVIDE_F(1.0),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0.0),
    .CLKOUT1_PHASE(0.0),
    .CLKOUT2_PHASE(0.0),
    .CLKOUT3_PHASE(0.0),
    .CLKOUT4_PHASE(0.0),
    .CLKOUT5_PHASE(0.0),
    .CLKOUT6_PHASE(0.0),
    .CLKOUT4_CASCADE("FALSE"),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.0),
    .STARTUP_WAIT("FALSE")
)
MMCME2_BASE_INST (
    .CLKOUT0(),
    .CLKOUT0B(),
    .CLKOUT1(MMCM_pix_clock),
    .CLKOUT1B(),
    .CLKOUT2(DCM_TMDS_CLKFX),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(clkfb_in),
    .CLKFBOUTB(),
    .LOCKED(),
    .CLKIN1(clk),
    .PWRDWN(1'b0), // Power down not used
    .RST(1'b0), // Reset not used
    .CLKFBIN(clkfb_out)
);

BUFG BUFG_pixclk (
    .O(pixclk),
    .I(MMCM_pix_clock)
);

BUFG BUFG_TMDSp (
    .O(clk_TMDS),
    .I(DCM_TMDS_CLKFX)
);

BUFG BUFG_CLKFB (
    .O(clkfb_out),
    .I(clkfb_in)
);

// Counter and sync generation
reg [9:0] CounterX = 0, CounterY = 0;
reg hSync, vSync, DrawArea;
wire [7:0] red, green, blue;

always @(posedge pixclk) begin
    DrawArea <= (CounterX < 640) && (CounterY < 480); // Define picture dimensions for 640x480
    CounterX <= (CounterX == 799) ? 0 : CounterX + 1; // Horizontal counter
    if (CounterX == 799) 
        CounterY <= (CounterY == 524) ? 0 : CounterY + 1; // Vertical counter

    hSync <= (CounterX >= 656) && (CounterX < 752); // HSYNC signal
    vSync <= (CounterY >= 490) && (CounterY < 492); // VSYNC signal
end

parameter memOffset = 0;
parameter hx = 2;
parameter yx = 2;

wire [31:0] yoffset;
wire [31:0] xoffset;

assign yoffset = (CounterY / yx) * 10;
assign xoffset = (CounterX / 64);
assign pointer = memOffset + yoffset + xoffset;

wire [5:0] mod = CounterX % 64;
assign red = (displayData[mod / 2] == 1'b1) ? 8'd52 : 8'd45;
assign blue = (displayData[mod / 2] == 1'b1) ? 8'd164 : 8'd34;
assign green = (displayData[mod / 2] == 1'b1) ? 8'd101 : 8'd9;

wire [9:0] TMDS_red, TMDS_green, TMDS_blue;

// Instantiate TMDS encoders
TMDS_encoder encode_R(.clk(pixclk), .VD(red), .CD(2'b00), .VDE(DrawArea), .TMDS(TMDS_red));
TMDS_encoder encode_G(.clk(pixclk), .VD(green), .CD(2'b00), .VDE(DrawArea), .TMDS(TMDS_green));
TMDS_encoder encode_B(.clk(pixclk), .VD(blue), .CD({vSync, hSync}), .VDE(DrawArea), .TMDS(TMDS_blue));

reg [3:0] TMDS_mod10 = 0; // Modulus 10 counter
reg [9:0] TMDS_shift_red = 0, TMDS_shift_green = 0, TMDS_shift_blue = 0;
reg TMDS_shift_load = 0;

always @(posedge clk_TMDS) 
    TMDS_shift_load <= (TMDS_mod10 == 4'd9); // Shift load high when mod 10 counter is done

always @(posedge clk_TMDS) begin
    TMDS_shift_red <= TMDS_shift_load ? TMDS_red : TMDS_shift_red[9:1];
    TMDS_shift_green <= TMDS_shift_load ? TMDS_green : TMDS_shift_green[9:1];
    TMDS_shift_blue <= TMDS_shift_load ? TMDS_blue : TMDS_shift_blue[9:1];	
    TMDS_mod10 <= (TMDS_mod10 == 4'd9) ? 4'd0 : TMDS_mod10 + 4'd1; // Counter increment
end

// Output buffers
OBUFDS #(
    .IOSTANDARD("DEFAULT"),
    .SLEW("SLOW")
) OBUFDS_red (
    .O(TMDSp[2]),
    .OB(TMDSn[2]),
    .I(TMDS_shift_red[0])
);

OBUFDS #(
    .IOSTANDARD("DEFAULT"),
    .SLEW("SLOW")
) OBUFDS_green (
    .O(TMDSp[1]),
    .OB(TMDSn[1]),
    .I(TMDS_shift_green[0])
);

OBUFDS #(
    .IOSTANDARD("DEFAULT"),
    .SLEW("SLOW")
) OBUFDS_blue (
    .O(TMDSp[0]),
    .OB(TMDSn[0]),
    .I(TMDS_shift_blue[0])
);

OBUFDS #(
    .IOSTANDARD("DEFAULT"),
    .SLEW("SLOW")
) OBUFDS_clock (
    .O(TMDSp_clock),
    .OB(TMDSn_clock),
    .I(pixclk)
);

endmodule // DisplayDriver
