`timescale 1ns/1ps

module status_register_tb();

    reg clk;
    reg reset;
    reg i_Memory_Ins;
    reg [3:0] i_Status;
    wire [3:0] o_Status;

    // Instantiate the Unit Under Test (UUT)
    status_register uut (
        .clk(clk),
        .reset(reset),
        .i_Memory_Ins(i_Memory_Ins),
        .i_Status(i_Status),
        .o_Status(o_Status)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        i_Memory_Ins = 0;
        i_Status = 4'b0000;

        // Apply reset
        #10 reset = 1;
        #10 reset = 0;

        // Test case 1: No memory instruction, status should not change
        #10 i_Status = 4'b1010;
        #10 if (o_Status !== 4'b0000) $display("Test case 1 failed");

        // Test case 2: Memory instruction, status should update
        #10 i_Memory_Ins = 1;
        i_Status = 4'b1100;
        #10 if (o_Status !== 4'b1100) $display("Test case 2 failed");

        // Test case 3: No memory instruction, status should not change
        #10 i_Memory_Ins = 0;
        i_Status = 4'b0011;
        #10 if (o_Status !== 4'b1100) $display("Test case 3 failed");

        // Test case 4: Memory instruction, status should update
        #10 i_Memory_Ins = 1;
        i_Status = 4'b0101;
        #10 if (o_Status !== 4'b0101) $display("Test case 4 failed");

        // Test case 5: Reset, status should clear
        #10 reset = 1;
        #10 if (o_Status !== 4'b0000) $display("Test case 5 failed");

        $display("Testbench completed");
        $finish;
    end

endmodule
