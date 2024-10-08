`timescale 1ns/1ps

module wb_stage_tb;

    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg reset;
    reg [DATA_WIDTH - 1:0] i_Pc;
    reg i_Sig_Write_Back_Enable;
    reg i_Sig_Memory_Read_Enable;
    reg [DATA_WIDTH - 1:0] i_ALU_Result;
    reg [3:0] i_Destination;
    reg [DATA_WIDTH - 1:0] i_Data_Memory;

    wire [DATA_WIDTH - 1:0] o_Pc;
    wire o_Sig_Write_Back_Enable;
    wire [DATA_WIDTH - 1:0] o_Write_Back_Value;
    wire [3:0] o_Destination;

    // Instantiate the Unit Under Test (UUT)
    wb_stage uut (
        .clk(clk),
        .reset(reset),
        .i_Pc(i_Pc),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_ALU_Result(i_ALU_Result),
        .i_Destination(i_Destination),
        .i_Data_Memory(i_Data_Memory),
        .o_Pc(o_Pc),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_Write_Back_Value(o_Write_Back_Value),
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
        i_Pc = 0;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 0;
        i_Destination = 0;
        i_Data_Memory = 0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Write back ALU result
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 32'hABCD1234;
        i_Destination = 4'b0001;
        i_Data_Memory = 32'h00000000;
        #CLK_PERIOD;

        // Test case 2: Write back memory data
        i_Pc = 32'h1004;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 1;
        i_ALU_Result = 32'h11223344;
        i_Destination = 4'b0010;
        i_Data_Memory = 32'h55667788;
        #CLK_PERIOD;

        // Test case 3: No write back
        i_Pc = 32'h1008;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 32'hAABBCCDD;
        i_Destination = 4'b0011;
        i_Data_Memory = 32'hEEFF0011;
        #CLK_PERIOD;

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, PC=%h, WB_EN=%b, MEM_R_EN=%b, ALU_RES=%h, DEST=%b, DATA_MEM=%h, O_PC=%h, O_WB_EN=%b, O_WB_VAL=%h, O_DEST=%b",
                 $time, i_Pc, i_Sig_Write_Back_Enable, i_Sig_Memory_Read_Enable, i_ALU_Result, i_Destination, i_Data_Memory,
                 o_Pc, o_Sig_Write_Back_Enable, o_Write_Back_Value, o_Destination);
    end

endmodule
