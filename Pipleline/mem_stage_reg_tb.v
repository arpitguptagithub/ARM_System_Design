`timescale 1ns/1ps

module mem_stage_reg_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period
    parameter DATA_WIDTH = 32;

    // Inputs
    reg clk;
    reg reset;
    reg i_Sig_Write_Back_Enable;
    reg i_Sig_Memory_Read_Enable;
    reg [DATA_WIDTH-1:0] i_ALU_Result;
    reg [DATA_WIDTH-1:0] i_Memory_Read_Value;
    reg [3:0] i_Destination;

    // Outputs
    wire o_Sig_Write_Back_Enable;
    wire o_Sig_Memory_Read_Enable;
    wire [DATA_WIDTH-1:0] o_ALU_Result;
    wire [DATA_WIDTH-1:0] o_Memory_Read_Value;
    wire [3:0] o_Destination;

    // Instantiate the Unit Under Test (UUT)
    mem_stage_reg uut (
        .clk(clk),
        .reset(reset),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_ALU_Result(i_ALU_Result),
        .i_Memory_Read_Value(i_Memory_Read_Value),
        .i_Destination(i_Destination),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_Sig_Memory_Read_Enable(o_Sig_Memory_Read_Enable),
        .o_ALU_Result(o_ALU_Result),
        .o_Memory_Read_Value(o_Memory_Read_Value),
        .o_Destination(o_Destination)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize inputs
        reset = 1;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 0;
        i_Memory_Read_Value = 0;
        i_Destination = 0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation
        #CLK_PERIOD;
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 1;
        i_ALU_Result = 32'hABCD1234;
        i_Memory_Read_Value = 32'h98765432;
        i_Destination = 4'b1010;
        #CLK_PERIOD;

        // Test case 2: Change values
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Memory_Read_Enable = 1;
        i_ALU_Result = 32'h11223344;
        i_Memory_Read_Value = 32'h55667788;
        i_Destination = 4'b0101;
        #CLK_PERIOD;

        // Test case 3: Reset during operation
        #(CLK_PERIOD/2);
        reset = 1;
        #CLK_PERIOD;
        reset = 0;
        #(CLK_PERIOD/2);

        // Test case 4: Normal operation after reset
        i_Sig_Write_Back_Enable = 1;
        i_Sig_Memory_Read_Enable = 0;
        i_ALU_Result = 32'hFFEEDDCC;
        i_Memory_Read_Value = 32'hBBAA9988;
        i_Destination = 4'b1111;
        #CLK_PERIOD;

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, Reset=%b, WB_EN_in=%b, MEM_R_EN_in=%b, ALU_RES_in=%h, MEM_READ_in=%h, DEST_in=%b, WB_EN_out=%b, MEM_R_EN_out=%b, ALU_RES_out=%h, MEM_READ_out=%h, DEST_out=%b",
                 $time, reset, i_Sig_Write_Back_Enable, i_Sig_Memory_Read_Enable, i_ALU_Result, i_Memory_Read_Value, i_Destination,
                 o_Sig_Write_Back_Enable, o_Sig_Memory_Read_Enable, o_ALU_Result, o_Memory_Read_Value, o_Destination);
    end

endmodule
