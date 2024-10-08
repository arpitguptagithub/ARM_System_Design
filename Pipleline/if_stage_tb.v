`timescale 1ns / 1ps

module if_stage_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Freeze;
    reg i_Branch_Taken;
    reg [DATA_WIDTH-1:0] i_Branch_Address;

    // Outputs
    wire [DATA_WIDTH-1:0] o_Pc;
    wire [DATA_WIDTH-1:0] o_Instruction;

    // Instantiate the Unit Under Test (UUT)
    if_stage uut (
        .clk(clk),
        .reset(reset),
        .i_Freeze(i_Freeze),
        .i_Branch_Taken(i_Branch_Taken),
        .i_Branch_Address(i_Branch_Address),
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
        i_Branch_Taken = 0;
        i_Branch_Address = 32'h0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Normal operation (no freeze, no branch)
        #CLK_PERIOD;
        if (o_Pc !== 32'h4) $display("Error: PC not incremented correctly");

        // Test case 2: Freeze
        i_Freeze = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h4) $display("Error: PC changed during freeze");
        i_Freeze = 0;

        // Test case 3: Branch taken
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h1000;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1000) $display("Error: Branch not taken correctly");
        i_Branch_Taken = 0;

        // Test case 4: Multiple cycles of normal operation
        #(CLK_PERIOD*3);
        if (o_Pc !== 32'h100C) $display("Error: PC not incremented correctly after branch");

        // Test case 5: Reset during operation
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0) $display("Error: Reset not working correctly");
        reset = 0;

        // Test case 6: Freeze followed by branch
        #CLK_PERIOD;
        i_Freeze = 1;
        #CLK_PERIOD;
        i_Freeze = 0;
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h2000;
        #CLK_PERIOD;
        if (o_Pc !== 32'h2000) $display("Error: Branch after freeze not working correctly");
        i_Branch_Taken = 0;

        // Test case 7: Consecutive branches
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h3000;
        #CLK_PERIOD;
        if (o_Pc !== 32'h3000) $display("Error: First consecutive branch not taken correctly");
        i_Branch_Address = 32'h4000;
        #CLK_PERIOD;
        if (o_Pc !== 32'h4000) $display("Error: Second consecutive branch not taken correctly");
        i_Branch_Taken = 0;

        // Test case 8: Freeze during branch
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h5000;
        i_Freeze = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h4000) $display("Error: PC changed during freeze while branching");
        i_Freeze = 0;
        #CLK_PERIOD;
        if (o_Pc !== 32'h5000) $display("Error: Branch not taken correctly after freeze");
        i_Branch_Taken = 0;

        // Test case 9: Reset during freeze
        i_Freeze = 1;
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        if (o_Pc !== 32'h0) $display("Error: Reset not working correctly during freeze");
        reset = 0;
        i_Freeze = 0;

        // Test case 10: Branch to odd address
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h1001;
        #CLK_PERIOD;
        if (o_Pc !== 32'h1001) $display("Error: Branch to odd address not handled correctly");
        i_Branch_Taken = 0;

        // Test case 11: Rapid toggling of freeze
        #CLK_PERIOD;
        i_Freeze = 1;
        #1;
        i_Freeze = 0;
        #1;
        i_Freeze = 1;
        #1;
        i_Freeze = 0;
        #(CLK_PERIOD-3);
        if (o_Pc !== 32'h1005) $display("Error: Rapid toggling of freeze not handled correctly");

        // Test case 12: Branch with maximum address
        i_Branch_Taken = 1;
        i_Branch_Address = 32'hFFFFFFFC;
        #CLK_PERIOD;
        if (o_Pc !== 32'hFFFFFFFC) $display("Error: Branch to maximum address not handled correctly");
        i_Branch_Taken = 0;

        // Test case 13: Normal operation after maximum address
        #CLK_PERIOD;
        if (o_Pc !== 32'h0) $display("Error: PC overflow not handled correctly");

        // Test case 14: Freeze for multiple cycles
        i_Freeze = 1;
        #(CLK_PERIOD*5);
        if (o_Pc !== 32'h0) $display("Error: PC changed during extended freeze");
        i_Freeze = 0;

        // Test case 15: Alternating branch and normal operation
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h8000;
        #CLK_PERIOD;
        i_Branch_Taken = 0;
        #CLK_PERIOD;
        i_Branch_Taken = 1;
        i_Branch_Address = 32'h9000;
        #CLK_PERIOD;
        i_Branch_Taken = 0;
        #CLK_PERIOD;
        if (o_Pc !== 32'h9004) $display("Error: Alternating branch and normal operation not handled correctly");

        // End simulation
        #(CLK_PERIOD*2);
        $display("IF Stage Testbench completed");
        $finish;
    end

    // Monitor changes
    always @(o_Pc or o_Instruction) begin
        $display("Time=%0t: PC=%h, Instruction=%h", $time, o_Pc, o_Instruction);
    end

endmodule

