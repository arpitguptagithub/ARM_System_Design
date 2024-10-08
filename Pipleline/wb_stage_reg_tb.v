`timescale 1ns/1ps

module wb_stage_reg_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] i_Pc;
    reg i_Sig_Write_Back_Enable;
    reg [31:0] i_Write_Back_Value;
    reg [3:0] i_Destination;

    // Outputs
    wire [31:0] o_Pc;
    wire o_Sig_Write_Back_Enable;
    wire [31:0] o_Write_Back_Value;
    wire [3:0] o_Destination;

    // Instantiate the Unit Under Test (UUT)
    wb_stage_reg uut (
        .clk(clk),
        .reset(reset),
        .i_Pc(i_Pc),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Write_Back_Value(i_Write_Back_Value),
        .i_Destination(i_Destination),
        .o_Pc(o_Pc),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_Write_Back_Value(o_Write_Back_Value),
        .o_Destination(o_Destination)
    );

    // Clock generation
    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        i_Pc = 0;
        i_Sig_Write_Back_Enable = 0;
        i_Write_Back_Value = 0;
        i_Destination = 0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Write_Back_Enable = 1;
        i_Write_Back_Value = 32'hABCD1234;
        i_Destination = 4'b1010;
        #CLK_PERIOD;

        // Test case 2: Change values
        i_Pc = 32'h1004;
        i_Sig_Write_Back_Enable = 0;
        i_Write_Back_Value = 32'h55667788;
        i_Destination = 4'b0101;
        #CLK_PERIOD;

        // Test case 3: Reset during operation
        #(CLK_PERIOD/2);
        reset = 1;
        #CLK_PERIOD;
        reset = 0;
        #(CLK_PERIOD/2);

        // Test case 4: Normal operation after reset
        i_Pc = 32'h2000;
        i_Sig_Write_Back_Enable = 1;
        i_Write_Back_Value = 32'hFFEEDDCC;
        i_Destination = 4'b1111;
        #CLK_PERIOD;

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, Reset=%b, PC_in=%h, WB_EN_in=%b, WB_Value_in=%h, DEST_in=%b, PC_out=%h, WB_EN_out=%b, WB_Value_out=%h, DEST_out=%b",
                 $time, reset, i_Pc, i_Sig_Write_Back_Enable, i_Write_Back_Value, i_Destination,
                 o_Pc, o_Sig_Write_Back_Enable, o_Write_Back_Value, o_Destination);
    end

endmodule
