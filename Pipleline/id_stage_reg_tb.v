`timescale 1ns / 1ps

module id_stage_reg_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Flush;
    reg i_Freeze;
    reg [DATA_WIDTH-1:0] i_Pc;
    reg i_Sig_Memory_Read_Enable;
    reg i_Sig_Memory_Write_Enable;
    reg i_Sig_Write_Back_Enable;
    reg i_Sig_Status_Write_Enable;
    reg i_Branch_Taken;
    reg i_Immediate;
    reg [3:0] i_Sigs_Control;
    reg [DATA_WIDTH-1:0] i_Value_Rm;
    reg [DATA_WIDTH-1:0] i_Value_Rn;
    reg [23:0] i_Signed_Immediate_24;
    reg [3:0] i_Destination;
    reg [11:0] i_Shift_Operand;
    reg i_Carry_In;
    reg [3:0] i_Src_1;
    reg [3:0] i_Src_2;

    // Outputs
    wire [DATA_WIDTH-1:0] o_Pc;
    wire o_Sig_Memory_Read_Enable;
    wire o_Sig_Memory_Write_Enable;
    wire o_Sig_Write_Back_Enable;
    wire o_Sig_Status_Write_Enable;
    wire o_Branch_Taken;
    wire o_Immediate;
    wire [3:0] o_Sigs_Control;
    wire [DATA_WIDTH-1:0] o_Value_Rm;
    wire [DATA_WIDTH-1:0] o_Value_Rn;
    wire [23:0] o_Signed_Immediate_24;
    wire [3:0] o_Destination;
    wire [11:0] o_Shift_Operand;
    wire o_Carry;
    wire [3:0] o_Src_1;
    wire [3:0] o_Src_2;

    // Instantiate the Unit Under Test (UUT)
    id_stage_reg uut (
        .clk(clk),
        .reset(reset),
        .i_Flush(i_Flush),
        .i_Freeze(i_Freeze),
        .i_Pc(i_Pc),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_Sig_Memory_Write_Enable(i_Sig_Memory_Write_Enable),
        .i_Sig_Write_Back_Enable(i_Sig_Write_Back_Enable),
        .i_Sig_Status_Write_Enable(i_Sig_Status_Write_Enable),
        .i_Branch_Taken(i_Branch_Taken),
        .i_Immediate(i_Immediate),
        .i_Sigs_Control(i_Sigs_Control),
        .i_Value_Rm(i_Value_Rm),
        .i_Value_Rn(i_Value_Rn),
        .i_Signed_Immediate_24(i_Signed_Immediate_24),
        .i_Destination(i_Destination),
        .i_Shift_Operand(i_Shift_Operand),
        .i_Carry_In(i_Carry_In),
        .i_Src_1(i_Src_1),
        .i_Src_2(i_Src_2),
        .o_Pc(o_Pc),
        .o_Sig_Memory_Read_Enable(o_Sig_Memory_Read_Enable),
        .o_Sig_Memory_Write_Enable(o_Sig_Memory_Write_Enable),
        .o_Sig_Write_Back_Enable(o_Sig_Write_Back_Enable),
        .o_Sig_Status_Write_Enable(o_Sig_Status_Write_Enable),
        .o_Branch_Taken(o_Branch_Taken),
        .o_Immediate(o_Immediate),
        .o_Sigs_Control(o_Sigs_Control),
        .o_Value_Rm(o_Value_Rm),
        .o_Value_Rn(o_Value_Rn),
        .o_Signed_Immediate_24(o_Signed_Immediate_24),
        .o_Destination(o_Destination),
        .o_Shift_Operand(o_Shift_Operand),
        .o_Carry(o_Carry),
        .o_Src_1(o_Src_1),
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
        i_Flush = 0;
        i_Freeze = 0;
        i_Pc = 32'h0;
        i_Sig_Memory_Read_Enable = 0;
        i_Sig_Memory_Write_Enable = 0;
        i_Sig_Write_Back_Enable = 0;
        i_Sig_Status_Write_Enable = 0;
        i_Branch_Taken = 0;
        i_Immediate = 0;
        i_Sigs_Control = 4'b0;
        i_Value_Rm = 32'h0;
        i_Value_Rn = 32'h0;
        i_Signed_Immediate_24 = 24'h0;
        i_Destination = 4'b0;
        i_Shift_Operand = 12'h0;
        i_Carry_In = 0;
        i_Src_1 = 4'b0;
        i_Src_2 = 4'b0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation
        #CLK_PERIOD;
        i_Pc = 32'h1000;
        i_Sig_Memory_Read_Enable = 1;
        i_Sigs_Control = 4'b1010;
        i_Value_Rm = 32'hABCD1234;
        i_Destination = 4'b0101;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1000) $display("Error: PC not latched correctly");
        if (o_Sig_Memory_Read_Enable !== 1) $display("Error: Memory Read Enable not latched correctly");
        if (o_Sigs_Control !== 4'b1010) $display("Error: Control signals not latched correctly");
        if (o_Value_Rm !== 32'hABCD1234) $display("Error: Rm value not latched correctly");
        if (o_Destination !== 4'b0101) $display("Error: Destination not latched correctly");

        // Test case 2: Freeze
        i_Freeze = 1;
        i_Pc = 32'h2000;
        i_Sig_Memory_Read_Enable = 0;
        i_Sigs_Control = 4'b0101;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1000) $display("Error: PC changed during freeze");
        if (o_Sig_Memory_Read_Enable !== 1) $display("Error: Memory Read Enable changed during freeze");
        if (o_Sigs_Control !== 4'b1010) $display("Error: Control signals changed during freeze");
        i_Freeze = 0;

        // Test case 3: Flush
        #CLK_PERIOD;
        i_Flush = 1;
        i_Pc = 32'h3000;
        i_Sig_Memory_Write_Enable = 1;
        i_Branch_Taken = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h3000) $display("Error: PC not updated during flush");
        if (o_Sig_Memory_Read_Enable !== 0) $display("Error: Memory Read Enable not reset during flush");
        if (o_Sig_Memory_Write_Enable !== 0) $display("Error: Memory Write Enable not reset during flush");
        if (o_Branch_Taken !== 0) $display("Error: Branch Taken not reset during flush");
        i_Flush = 0;

        // Test case 4: Multiple cycles of normal operation
        #CLK_PERIOD;
        i_Pc = 32'h4000;
        i_Sig_Write_Back_Enable = 1;
        i_Immediate = 1;
        i_Value_Rn = 32'h98765432;
        #CLK_PERIOD;
        if (o_Pc !== 32'h4000) $display("Error: PC not updated correctly");
        if (o_Sig_Write_Back_Enable !== 1) $display("Error: Write Back Enable not latched correctly");
        if (o_Immediate !== 1) $display("Error: Immediate flag not latched correctly");
        if (o_Value_Rn !== 32'h98765432) $display("Error: Rn value not latched correctly");

        // Test case 5: Reset during operation
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0) $display("Error: PC not reset");
        if (o_Sig_Memory_Read_Enable !== 0) $display("Error: Memory Read Enable not reset");
        if (o_Sig_Memory_Write_Enable !== 0) $display("Error: Memory Write Enable not reset");
        if (o_Sig_Write_Back_Enable !== 0) $display("Error: Write Back Enable not reset");
        if (o_Branch_Taken !== 0) $display("Error: Branch Taken not reset");
        if (o_Immediate !== 0) $display("Error: Immediate flag not reset");
        if (o_Sigs_Control !== 4'b0) $display("Error: Control signals not reset");
        reset = 0;

        // End simulation
        #(CLK_PERIOD*2);
        $display("ID Stage Register Testbench completed");
        $finish;
    end

endmodule
