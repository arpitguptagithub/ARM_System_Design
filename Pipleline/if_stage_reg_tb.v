`timescale 1ns / 1ps

module if_stage_reg_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Freeze;
    reg i_Flush;
    reg [DATA_WIDTH-1:0] i_Pc;
    reg [DATA_WIDTH-1:0] i_Instruction;

    // Outputs
    wire [DATA_WIDTH-1:0] o_Pc;
    wire [DATA_WIDTH-1:0] o_Instruction;

    // Instantiate the Unit Under Test (UUT)
    if_stage_reg uut (
        .clk(clk),
        .reset(reset),
        .i_Freeze(i_Freeze),
        .i_Flush(i_Flush),
        .i_Pc(i_Pc),
        .i_Instruction(i_Instruction),
        .o_Pc(o_Pc),
        .o_Instruction(o_Instruction)
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
        i_Freeze = 0;
        i_Flush = 0;
        i_Pc = 32'h0;
        i_Instruction = 32'h0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation (no freeze, no flush)
        i_Pc = 32'h4;
        i_Instruction = 32'hE0821003; // ADD R1, R2, R3
        #CLK_PERIOD;
        if (o_Pc !== 32'h4 || o_Instruction !== 32'hE0821003) $display("Error: Normal operation not working correctly");

        // Test case 2: Freeze
        i_Pc = 32'h8;
        i_Instruction = 32'hE5924000; // LDR R4, [R2]
        i_Freeze = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h4 || o_Instruction !== 32'hE0821003) $display("Error: Freeze not working correctly");
        i_Freeze = 0;

        // Test case 3: Flush
        i_Pc = 32'hC;
        i_Instruction = 32'hE5835000; // STR R5, [R3]
        i_Flush = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0 || o_Instruction !== 32'h0) $display("Error: Flush not working correctly");
        i_Flush = 0;

        // Test case 4: Multiple cycles of normal operation
        i_Pc = 32'h10;
        i_Instruction = 32'hE3A06005; // MOV R6, #5
        #CLK_PERIOD;
        i_Pc = 32'h14;
        i_Instruction = 32'hEA000003; // B +3 (PC + 12)
        #CLK_PERIOD;
        i_Pc = 32'h18;
        i_Instruction = 32'hE1570008; // CMP R7, R8
        #CLK_PERIOD;
        if (o_Pc !== 32'h18 || o_Instruction !== 32'hE1570008) $display("Error: Multiple cycles not working correctly");

        // Test case 5: Freeze followed by normal operation
        i_Pc = 32'h1C;
        i_Instruction = 32'hE0821003; // ADD R1, R2, R3
        i_Freeze = 1;
        #CLK_PERIOD;
        i_Freeze = 0;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1C || o_Instruction !== 32'hE0821003) $display("Error: Freeze followed by normal operation not working correctly");

        // Test case 6: Flush followed by normal operation
        i_Pc = 32'h20;
        i_Instruction = 32'hE5924000; // LDR R4, [R2]
        i_Flush = 1;
        #CLK_PERIOD;
        i_Flush = 0;
        i_Pc = 32'h24;
        i_Instruction = 32'hE5835000; // STR R5, [R3]
        #CLK_PERIOD;
        if (o_Pc !== 32'h24 || o_Instruction !== 32'hE5835000) $display("Error: Flush followed by normal operation not working correctly");

        // Test case 7: Reset during operation
        i_Pc = 32'h28;
        i_Instruction = 32'hE3A06005; // MOV R6, #5
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0 || o_Instruction !== 32'h0) $display("Error: Reset not working correctly");
        reset = 0;

        // End simulation
        #(CLK_PERIOD*2);
        $display("IF Stage Register Testbench completed");
        $finish;
    end

    // Monitor changes
    always @(o_Pc or o_Instruction) begin
        $display("Time=%0t: PC=%h, Instruction=%h", $time, o_Pc, o_Instruction);
    end

endmodule
