`timescale 1ns/1ps

module mem_stage_tb();

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg [DATA_WIDTH-1:0] i_Pc;
    reg i_Sig_Write_Back_Enable;
    reg i_Sig_Memory_Read_Enable;
    reg i_Sig_Memory_Write_Enable;
    reg [DATA_WIDTH-1:0] i_ALU_Result;
    reg [DATA_WIDTH-1:0] i_Value_Rm;
    reg [3:0] i_Destination;

    // Outputs
    wire [DATA_WIDTH-1:0] o_Pc;
    wire o_Sig_Write_Back_Enable;
    wire o_Sig_Memory_Read_Enable;
    wire [DATA_WIDTH-1:0] o_Memory_Result;
    wire [3:0] o_Destination;
    wire [DATA_WIDTH-1:0] o_Data_Memory;

    // Instantiate the Unit Under Test (UUT)
    mem_stage uut (
        .clk(clk),
        .reset(reset),
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
        .o_Memory_Result(o_Memory_Result),
        .o_Destination(o_Destination),
        .o_Data_Memory(o_Data_Memory)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Test scenario
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        i_Pc = 0;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_Sig_Memory_Write_Enable = 0;
        i_ALU_Result = 0;
        i_Value_Rm = 0;
        i_Destination = 0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Write to memory
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Write_Enable = 1;
        i_ALU_Result = 32'h2000; // Memory address
        i_Value_Rm = 32'hABCD1234; // Data to write
        i_Destination = 4'b0001;
        #CLK_PERIOD;

        // Test case 2: Read from memory
        i_Sig_Memory_Write_Enable = 0;
        i_Sig_Memory_Read_Enable = 1;
        #CLK_PERIOD;

        // Test case 3: No memory operation
        i_Pc = 32'h1004;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 32'h3000;
        i_Destination = 4'b0010;
        #CLK_PERIOD;

        // Add more test cases as needed

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, PC=%h, WB_EN=%b, MEM_R_EN=%b, MEM_W_EN=%b, ALU_RES=%h, VAL_RM=%h, DEST=%b, O_PC=%h, O_WB_EN=%b, O_MEM_R_EN=%b, O_MEM_RES=%h, O_DEST=%b, O_DATA_MEM=%h",
                 $time, i_Pc, i_Sig_Write_Back_Enable, i_Sig_Memory_Read_Enable, i_Sig_Memory_Write_Enable, i_ALU_Result, i_Value_Rm, i_Destination,
                 o_Pc, o_Sig_Write_Back_Enable, o_Sig_Memory_Read_Enable, o_Memory_Result, o_Destination, o_Data_Memory);
    end

endmodule
