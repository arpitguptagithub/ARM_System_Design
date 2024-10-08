`timescale 1ns/1ps

module exe_stage_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] i_Pc;
    reg i_Sig_Memory_Read_Enable;
    reg i_Sig_Memory_Write_Enable;
    reg i_Sig_Write_Back_Enable;
    reg i_Immediate;
    reg i_Carry_In;
    reg [11:0] i_Shift_Operand;
    reg [3:0] i_Sigs_Control;
    reg [31:0] i_Val_Rm;
    reg [31:0] i_Val_Rn;
    reg [23:0] i_Signed_Immediate_24;
    reg [3:0] i_Destination;
    reg [1:0] i_Sel_Src_1;
    reg [1:0] i_Sel_Src_2;
    reg [31:0] i_Memory_Write_Back_Value;
    reg [31:0] i_Write_Back_Write_Back_Value;

    // Outputs
    wire [31:0] o_Branch_Address;
    wire [3:0] o_ALU_Status;
    wire o_Sig_Memory_Read_Enable;
    wire o_Sig_Memory_Write_Enable;
    wire o_Sig_Write_Back_Enable;
    wire [31:0] o_ALU_Result;
    wire [31:0] o_Val_Rm;
    wire [3:0] o_Destination;

    // Instantiate the Unit Under Test (UUT)
    exe_stage uut (
        .clk(clk),
        .reset(reset),
        .i_Pc(i_Pc),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_Sig_Memory_Write_Enable(i_Sig_Memory_Write_Enable),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Immediate(i_Immediate),
        .i_Carry_In(i_Carry_In),
        .i_Shift_Operand(i_Shift_Operand),
        .i_Sigs_Control(i_Sigs_Control),
        .i_Val_Rm(i_Val_Rm),
        .i_Val_Rn(i_Val_Rn),
        .i_Signed_Immediate_24(i_Signed_Immediate_24),
        .i_Destination(i_Destination),
        .i_Sel_Src_1(i_Sel_Src_1),
        .i_Sel_Src_2(i_Sel_Src_2),
        .i_Memory_Write_Back_Value(i_Memory_Write_Back_Value),
        .i_Write_Back_Write_Back_Value(i_Write_Back_Write_Back_Value),
        .o_Branch_Address(o_Branch_Address),
        .o_ALU_Status(o_ALU_Status),
        .o_Sig_Memory_Read_Enable(o_Sig_Memory_Read_Enable),
        .o_Sig_Memory_Write_Enable(o_Sig_Memory_Write_Enable),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_ALU_Result(o_ALU_Result),
        .o_Val_Rm(o_Val_Rm),
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
        i_Pc = 32'h0;
        i_Sig_Memory_Read_Enable = 0;
        i_Sig_Memory_Write_Enable = 0;
        i_Sig_Write_Back_Enable = 0;
        i_Immediate = 0;
        i_Carry_In = 0;
        i_Shift_Operand = 12'h0;
        i_Sigs_Control = 4'b0;
        i_Val_Rm = 32'h0;
        i_Val_Rn = 32'h0;
        i_Signed_Immediate_24 = 24'h0;
        i_Destination = 4'b0;
        i_Sel_Src_1 = 2'b0;
        i_Sel_Src_2 = 2'b0;
        i_Memory_Write_Back_Value = 32'h0;
        i_Write_Back_Write_Back_Value = 32'h0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: ADD operation
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Write_Back_Enable = 1;
        i_Sigs_Control = 4'b0100; // ADD operation
        i_Val_Rm = 32'h00000005;
        i_Val_Rn = 32'h00000003;
        i_Destination = 4'b0001;
        #CLK_PERIOD;
        if (o_ALU_Result !== 32'h00000008) $display("Error: ADD operation failed");
        if (o_Destination !== 4'b0001) $display("Error: Destination not set correctly for ADD");

        // Test case 2: SUB operation with immediate
        #CLK_PERIOD;
        i_Pc = 32'h1004;
        i_Immediate = 1;
        i_Sigs_Control = 4'b0010; // SUB operation
        i_Val_Rn = 32'h0000000A;
        i_Shift_Operand = 12'h003;
        #CLK_PERIOD;
        if (o_ALU_Result !== 32'h00000007) $display("Error: SUB operation with immediate failed");

        // Test case 3: Memory operation (LDR)
        #CLK_PERIOD;
        i_Pc = 32'h1008;
        i_Sig_Memory_Read_Enable = 1;
        i_Sigs_Control = 4'b0100; // ADD for address calculation
        i_Val_Rn = 32'h10000000;
        i_Shift_Operand = 12'h100;
        #CLK_PERIOD;
        if (o_ALU_Result !== 32'h10000100) $display("Error: Address calculation for LDR failed");
        if (o_Sig_Memory_Read_Enable !== 1) $display("Error: Memory Read Enable not set for LDR");

        // Test case 4: Branch operation
        #CLK_PERIOD;
        i_Pc = 32'h100C;
        i_Signed_Immediate_24 = 24'h000100;
        #CLK_PERIOD;
        if (o_Branch_Address !== 32'h10000410) $display("Error: Branch address calculation failed");

        // Test case 5: Forwarding from Memory stage
        #CLK_PERIOD;
        i_Pc = 32'h1010;
        i_Sigs_Control = 4'b0100; // ADD operation
        i_Val_Rn = 32'h00000001;
        i_Sel_Src_2 = 2'b01; // Select forwarded value from Memory stage
        i_Memory_Write_Back_Value = 32'h00000002;
        #CLK_PERIOD;
        if (o_ALU_Result !== 32'h00000003) $display("Error: Forwarding from Memory stage failed");

        // Test case 6: Forwarding from WriteBack stage
        #CLK_PERIOD;
        i_Pc = 32'h1014;
        i_Sigs_Control = 4'b0100; // ADD operation
        i_Val_Rn = 32'h00000001;
        i_Sel_Src_2 = 2'b10; // Select forwarded value from WriteBack stage
        i_Write_Back_Write_Back_Value = 32'h00000003;
        #CLK_PERIOD;
        if (o_ALU_Result !== 32'h00000004) $display("Error: Forwarding from WriteBack stage failed");

        // End simulation
        #(CLK_PERIOD*2);
        $display("EXE Stage Testbench completed");
        $finish;
    end

endmodule
