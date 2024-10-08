// alu_tb.v
`timescale 1ns / 1ps

module alu_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10;

    // Inputs
    reg [DATA_WIDTH-1:0] i_A;
    reg [DATA_WIDTH-1:0] i_B;
    reg [3:0] i_Sigs_Control;
    reg i_Sig_Carry_In;

    // Outputs
    wire [DATA_WIDTH-1:0] o_ALU_Result;
    wire [3:0] o_Status;

    // Instantiate the Unit Under Test (UUT)
    alu #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .i_A(i_A),
        .i_B(i_B),
        .i_Sigs_Control(i_Sigs_Control),
        .i_Sig_Carry_In(i_Sig_Carry_In),
        .o_ALU_Result(o_ALU_Result),
        .o_Status(o_Status)
    );

    // Clock generation
    reg clk = 0;
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Test cases
    initial begin
        // Initialize inputs
        i_A = 0;
        i_B = 0;
        i_Sigs_Control = 0;
        i_Sig_Carry_In = 0;

        // Wait for global reset
        #100;

        // Test case 1: Pass B (4'b0001)
        i_A = 32'hAAAA_AAAA;
        i_B = 32'h5555_5555;
        i_Sigs_Control = 4'b0001;
        #10;
        if (o_ALU_Result !== 32'h5555_5555) $display("Test case 1 (Pass B) failed");

        // Test case 2: Bitwise NOT B (4'b1001)
        i_B = 32'h5555_5555;
        i_Sigs_Control = 4'b1001;
        #10;
        if (o_ALU_Result !== 32'hAAAA_AAAA) $display("Test case 2 (NOT B) failed");

        // Test case 3: Addition (4'b0010)
        i_A = 32'h0000_00A5;
        i_B = 32'h0000_005A;
        i_Sigs_Control = 4'b0010;
        #10;
        if (o_ALU_Result !== 32'h0000_00FF) $display("Test case 3 (Addition) failed");

        // Test case 4: Addition with Carry (4'b0011)
        i_A = 32'hFFFF_FFFF;
        i_B = 32'h0000_0001;
        i_Sig_Carry_In = 1'b1;
        i_Sigs_Control = 4'b0011;
        #10;
        if (o_ALU_Result !== 32'h0000_0001) $display("Test case 4 (Addition with Carry) failed");

        // Test case 5: Subtraction (4'b0100)
        i_A = 32'h0000_00FF;
        i_B = 32'h0000_00A5;
        i_Sig_Carry_In = 1'b0;
        i_Sigs_Control = 4'b0100;
        #10;
        if (o_ALU_Result !== 32'h0000_005A) $display("Test case 5 (Subtraction) failed");

        // Test case 6: Subtraction with Borrow (4'b0101)
        i_A = 32'h0000_0000;
        i_B = 32'h0000_0001;
        i_Sig_Carry_In = 1'b1;
        i_Sigs_Control = 4'b0101;
        #10;
        if (o_ALU_Result !== 32'hFFFF_FFFE) $display("Test case 6 (Subtraction with Borrow) failed");

        // Test case 7: Bitwise AND (4'b0110)
        i_A = 32'hFFFF_FFFF;
        i_B = 32'h0000_FFFF;
        i_Sigs_Control = 4'b0110;
        #10;
        if (o_ALU_Result !== 32'h0000_FFFF) $display("Test case 7 (AND) failed");

        // Test case 8: Bitwise OR (4'b0111)
        i_A = 32'hFFFF_0000;
        i_B = 32'h0000_FFFF;
        i_Sigs_Control = 4'b0111;
        #10;
        if (o_ALU_Result !== 32'hFFFF_FFFF) $display("Test case 8 (OR) failed");

        // Test case 9: Bitwise XOR (4'b1000)
        i_A = 32'hFFFF_FFFF;
        i_B = 32'h0000_FFFF;
        i_Sigs_Control = 4'b1000;
        #10;
        if (o_ALU_Result !== 32'hFFFF_0000) $display("Test case 9 (XOR) failed");

        $display("All tests completed");
        $finish;
    end

endmodule