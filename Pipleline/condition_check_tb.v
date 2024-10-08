`timescale 1ns/1ps

module condition_check_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg [3:0] i_Condition;
    reg [3:0] i_Status;

    // Outputs
    wire o_Result;

    // Instantiate the Unit Under Test (UUT)
    condition_check uut (
        .i_Condition(i_Condition),
        .i_Status(i_Status),
        .o_Result(o_Result)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        i_Condition = 4'b0000;
        i_Status = 4'b0000;

        // Wait for 100 ns for global reset
        #100;

        // Test case 1: EQ condition (Z=1)
        i_Condition = 4'b0000; // EQ
        i_Status = 4'b1000; // Z=1
        #CLK_PERIOD;

        // Test case 2: NE condition (Z=0)
        i_Condition = 4'b0001; // NE
        i_Status = 4'b0000; // Z=0
        #CLK_PERIOD;

        // Test case 3: CS/HS condition (C=1)
        i_Condition = 4'b0010; // CS/HS
        i_Status = 4'b0100; // C=1
        #CLK_PERIOD;

        // Test case 4: CC/LO condition (C=0)
        i_Condition = 4'b0011; // CC/LO
        i_Status = 4'b0000; // C=0
        #CLK_PERIOD;

        // Test case 5: MI condition (N=1)
        i_Condition = 4'b0100; // MI
        i_Status = 4'b0010; // N=1
        #CLK_PERIOD;

        // Test case 6: PL condition (N=0)
        i_Condition = 4'b0101; // PL
        i_Status = 4'b0000; // N=0
        #CLK_PERIOD;

        // Test case 7: VS condition (V=1)
        i_Condition = 4'b0110; // VS
        i_Status = 4'b0001; // V=1
        #CLK_PERIOD;

        // Test case 8: VC condition (V=0)
        i_Condition = 4'b0111; // VC
        i_Status = 4'b0000; // V=0
        #CLK_PERIOD;

        // Test case 9: HI condition (C=1 and Z=0)
        i_Condition = 4'b1000; // HI
        i_Status = 4'b0100; // C=1, Z=0
        #CLK_PERIOD;

        // Test case 10: LS condition (C=0 or Z=1)
        i_Condition = 4'b1001; // LS
        i_Status = 4'b1000; // C=0, Z=1
        #CLK_PERIOD;

        // Test case 11: GE condition (N=V)
        i_Condition = 4'b1010; // GE
        i_Status = 4'b0011; // N=1, V=1
        #CLK_PERIOD;

        // Test case 12: LT condition (N!=V)
        i_Condition = 4'b1011; // LT
        i_Status = 4'b0010; // N=1, V=0
        #CLK_PERIOD;

        // Test case 13: GT condition (Z=0 and N=V)
        i_Condition = 4'b1100; // GT
        i_Status = 4'b0000; // Z=0, N=0, V=0
        #CLK_PERIOD;

        // Test case 14: LE condition (Z=1 or N!=V)
        i_Condition = 4'b1101; // LE
        i_Status = 4'b1000; // Z=1
        #CLK_PERIOD;

        // Test case 15: AL condition (always)
        i_Condition = 4'b1110; // AL
        i_Status = 4'b0000; // Any status
        #CLK_PERIOD;

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, Condition=%b, Status=%b, Result=%b",
                 $time, i_Condition, i_Status, o_Result);
    end

endmodule
