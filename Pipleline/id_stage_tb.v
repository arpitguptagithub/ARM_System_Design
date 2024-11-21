`timescale 1ns / 1ps

module id_stage_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg [DATA_WIDTH-1:0] i_Pc;
    reg [DATA_WIDTH-1:0] i_Instruction;
    reg [3:0] i_Status;
    reg i_Sig_Write_Back;
    reg [DATA_WIDTH-1:0] i_Write_Back_Value;
    reg [3:0] i_Write_Back_Destination;
    reg i_Sig_Hazard;

    // Outputs
    wire [DATA_WIDTH-1:0] o_Pc;
    wire o_Sig_Memory_Read_Enable;
    wire o_Sig_Memory_Write_Enable;
    wire o_Write_Back_Enable;
    wire o_Sig_Branch_Taken;
    wire o_Immediate;
    wire [3:0] o_Sigs_Control;
    wire [DATA_WIDTH-1:0] o_Rm_Value;
    wire [DATA_WIDTH-1:0] o_Rn_Value;
    wire [23:0] o_Signed_Immediate_24;
    wire [3:0] o_Destination;
    wire [11:0] o_Shift_Operand;
    wire o_Two_Src;
    wire [3:0] o_Rn;
    wire [3:0] o_Src_2;

    // Instantiate the Unit Under Test (UUT)
    id_stage uut (
        .clk(clk),
        .reset(reset),
        .i_Pc(i_Pc),
        .i_Instruction(i_Instruction),
        .i_Status(i_Status),
        .i_Sig_Write_Back(i_Sig_Write_Back),
        .i_Write_Back_Value(i_Write_Back_Value),
        .i_Write_Back_Destination(i_Write_Back_Destination),
        .i_Sig_Hazard(i_Sig_Hazard),
        .o_Pc(o_Pc),
        .o_Sig_Memory_Read_Enable(o_Sig_Memory_Read_Enable),
        .o_Sig_Memory_Write_Enable(o_Sig_Memory_Write_Enable),
        .o_Write_Back_Enable(o_Write_Back_Enable),
        .o_Sig_Branch_Taken(o_Sig_Branch_Taken),
        .o_Immediate(o_Immediate),
        .o_Sigs_Control(o_Sigs_Control),
        .o_Rm_Value(o_Rm_Value),
        .o_Rn_Value(o_Rn_Value),
        .o_Signed_Immediate_24(o_Signed_Immediate_24),
        .o_Destination(o_Destination),
        .o_Shift_Operand(o_Shift_Operand),
        .o_Two_Src(o_Two_Src),
        .o_Rn(o_Rn),
        .o_Src_2(o_Src_2)
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
        i_Instruction = 32'h0;
        i_Status = 4'h0;
        i_Sig_Write_Back = 0;
        i_Write_Back_Value = 32'h0;
        i_Write_Back_Destination = 4'h0;
        i_Sig_Hazard = 0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: ADD instruction
        #CLK_PERIOD;
        i_Instruction = 32'hE0821003; // ADD R1, R2, R3
        i_Pc = 32'h1000;
        #CLK_PERIOD;
        if (o_Sigs_Control !== 4'b0100) $display("Error: ADD instruction not decoded correctly");
        if (o_Destination !== 4'b0001) $display("Error: Destination register not set correctly for ADD");
        if (o_Two_Src !== 1'b1) $display("Error: Two_Src not set for ADD instruction");

        // Test case 2: LDR instruction
        #CLK_PERIOD;
        i_Instruction = 32'hE5924000; // LDR R4, [R2]
        i_Pc = 32'h1004;
        #CLK_PERIOD;
        if (o_Sig_Memory_Read_Enable !== 1'b1) $display("Error: Memory Read Enable not set for LDR");
        if (o_Destination !== 4'b0100) $display("Error: Destination register not set correctly for LDR");

        // Test case 3: STR instruction
        #CLK_PERIOD;
        i_Instruction = 32'hE5835000; // STR R5, [R3]
        i_Pc = 32'h1008;
        #CLK_PERIOD;
        if (o_Sig_Memory_Write_Enable !== 1'b1) $display("Error: Memory Write Enable not set for STR");
        if (o_Two_Src !== 1'b1) $display("Error: Two_Src not set for STR instruction");

        // Test case 4: MOV instruction with immediate
        #CLK_PERIOD;
        i_Instruction = 32'hE3A06005; // MOV R6, #5
        i_Pc = 32'h100C;
        #CLK_PERIOD;
        if (o_Sigs_Control !== 4'b1101) $display("Error: MOV instruction not decoded correctly");
        if (o_Immediate !== 1'b1) $display("Error: Immediate flag not set for MOV immediate");
        if (o_Shift_Operand !== 12'h005) $display("Error: Immediate value not set correctly for MOV");

        // Test case 5: B (Branch) instruction
        #CLK_PERIOD;
        i_Instruction = 32'hEA000003; // B +3 (PC + 12)
        i_Pc = 32'h1010;
        #CLK_PERIOD;
        if (o_Signed_Immediate_24 !== 24'h000003) $display("Error: Branch offset not set correctly");
        if (o_Sig_Branch_Taken !== 1'b1) $display("Error: Branch not taken for B instruction");

        // Test case 6: CMP instruction
        #CLK_PERIOD;
        i_Instruction = 32'hE1570008; // CMP R7, R8
        i_Pc = 32'h1014;
        #CLK_PERIOD;
        if (o_Sigs_Control !== 4'b0101) $display("Error: CMP instruction not decoded correctly");
        if (o_Write_Back_Enable !== 1'b0) $display("Error: Write back enabled for CMP instruction");

        // Test case 7: Conditional execution (EQ condition)
        #CLK_PERIOD;
        i_Instruction = 32'h00821003; // ADDEQ R1, R2, R3
        i_Pc = 32'h1018;
        i_Status = 4'b0100; // Z flag set
        #CLK_PERIOD;
        if (o_Sigs_Control !== 4'b0100) $display("Error: ADDEQ not executed when Z flag is set");

        // Test case 8: Conditional execution (NE condition)
        #CLK_PERIOD;
        i_Instruction = 32'h10821003; // ADDNE R1, R2, R3
        i_Pc = 32'h101C;
        i_Status = 4'b0000; // Z flag clear
        #CLK_PERIOD;
        if (o_Sigs_Control !== 4'b0100) $display("Error: ADDNE not executed when Z flag is clear");

        // Test case 9: Write-back test
        #CLK_PERIOD;
        i_Instruction = 32'hE0821003; // ADD R1, R2, R3
        i_Pc = 32'h1020;
        i_Sig_Write_Back = 1;
        i_Write_Back_Value = 32'hABCDEF00;
        i_Write_Back_Destination = 4'b0010; // R2
        #CLK_PERIOD;
        if (o_Rn_Value !== 32'hABCDEF00) $display("Error: Write-back value not forwarded correctly");

        // Test case 10: Hazard condition
        #CLK_PERIOD;
        i_Instruction = 32'hE0821003; // ADD R1, R2, R3
        i_Pc = 32'h1024;
        i_Sig_Hazard = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1024) $display("Error: PC not held during hazard");
        if (o_Sigs_Control !== 4'b0000) $display("Error: Control signals not nullified during hazard");

        // End simulation
        #(CLK_PERIOD*2);
        $display("ID Stage Testbench completed");
        $finish;
    end

endmodule
