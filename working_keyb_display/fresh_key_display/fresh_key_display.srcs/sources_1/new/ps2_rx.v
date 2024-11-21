`timescale 1ns / 1ps


module ps2_rx
	(
		input wire clk, reset, 
		input wire ps2d, ps2c, rx_en,    // ps2 data and clock inputs, receive enable input
		output reg rx_done_tick,         // ps2 receive done tick
		output reg [7:0] rx_data         // data received 
	);
	
	reg [3:0] b;
	initial
	   begin
	       b <= 4'h1;
	       rx_done_tick <= 1'b0;
	   end
	
	always @(negedge ps2c)
	   begin
	       case(b)
	           1:;
	           2:rx_data[0] <= ps2d;
	           3:rx_data[1] <= ps2d;
	           4:rx_data[2] <= ps2d;
	           5:rx_data[3] <= ps2d;
	           6:rx_data[4] <= ps2d;
	           7:rx_data[5] <= ps2d;
	           8:rx_data[6] <= ps2d;
	           9:rx_data[7] <= ps2d;
	           10:rx_done_tick <= 1'b1;
	           11: rx_done_tick <= 1'b0;
	       endcase
	       if( b <= 10 )
	           b <= b+1;
	       else if( b == 11 )
	           b <= 1;
	   end
endmodule