`timescale 1ns/1ps

module exe_stage_reg_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Flush;
    reg i_Freeze;
    reg [31:0] i_Pc;
    reg i_Sig_Write_Back_Enable;
    reg i_Sig_Memory_Read_Enable;
    reg i_Sig_Memory_Write_Enable;
    reg [31:0] i_ALU_Result;
    reg [31:0] i_Value_Rm;
    reg [3:0] i_Destination;

    // Outputs
    wire [31:0] o_Pc;
    wire o_Sig_Write_Back_Enable;
    wire o_Sig_Memory_Read_Enable;
    wire o_Sig_Memory_Write_Enable;
    wire [31:0] o_ALU_Result;
    wire [31:0] o_Value_Rm;
    wire [3:0] o_Destination;

    // Instantiate the Unit Under Test (UUT)
    exe_stage_reg uut (
        .clk(clk),
        .reset(reset),
        .i_Flush(i_Flush),
        .i_Freeze(i_Freeze),
        .i_Pc(i_Pc),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_Sig_Memory_Write_Enable(i_Sig_Memory_Write_Enable),
        .i_ALU_Result(i_ALU_Result),
        .i_Value_Rm(i_Value_Rm),
        .i_Destination(i_Destination),
        .o_Pc(o_Pc),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_Sig_Memory_Read_Enable(o_Sig_Memory_Read_Enable),
        .o_Sig_Memory_Write_Enable(o_Sig_Memory_Write_Enable),
        .o_ALU_Result(o_ALU_Result),
        .o_Value_Rm(o_Value_Rm),
        .o_Destination(o_Destination)
    );

    // Clock generation
    always begin
        #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        i_Flush = 0;
        i_Freeze = 0;
        i_Pc = 32'h0;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_Sig_Memory_Write_Enable = 0;
        i_ALU_Result = 32'h0;
        i_Value_Rm = 32'h0;
        i_Destination = 4'h0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 1;
        i_Sig_Memory_Write_Enable = 0;
        i_ALU_Result = 32'hABCD1234;
        i_Value_Rm = 32'h98765432;
        i_Destination = 4'b1010;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1000 || o_Sig_Write_Back_Enable !== 1 || o_Sig_Memory_Read_Enable !== 1 ||
            o_Sig_Memory_Write_Enable !== 0 || o_ALU_Result !== 32'hABCD1234 || 
            o_Value_Rm !== 32'h98765432 || o_Destination !== 4'b1010)
            $display("Test case 1 failed");

        // Test case 2: Flush
        #CLK_PERIOD;
        i_Flush = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0 || o_Sig_Write_Back_Enable !== 0 || o_Sig_Memory_Read_Enable !== 0 ||
            o_Sig_Memory_Write_Enable !== 0 || o_ALU_Result !== 32'h0 || 
            o_Value_Rm !== 32'h0 || o_Destination !== 4'h0)
            $display("Test case 2 failed");
        i_Flush = 0;

        // Test case 3: Freeze
        #CLK_PERIOD;
        i_Pc = 32'h2000;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 0;
        i_Sig_Memory_Write_Enable = 1;
        i_ALU_Result = 32'h11223344;
        i_Value_Rm = 32'h55667788;
        i_Destination = 4'b0101;
        i_Freeze = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0 || o_Sig_Write_Back_Enable !== 0 || o_Sig_Memory_Read_Enable !== 0 ||
            o_Sig_Memory_Write_Enable !== 0 || o_ALU_Result !== 32'h0 || 
            o_Value_Rm !== 32'h0 || o_Destination !== 4'h0)
            $display("Test case 3 failed");
        i_Freeze = 0;

        // Test case 4: Reset
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0 || o_Sig_Write_Back_Enable !== 0 || o_Sig_Memory_Read_Enable !== 0 ||
            o_Sig_Memory_Write_Enable !== 0 || o_ALU_Result !== 32'h0 || 
            o_Value_Rm !== 32'h0 || o_Destination !== 4'h0)
            $display("Test case 4 failed");
        reset = 0;

        $display("All test cases completed");
        $finish;
    end

endmodule
