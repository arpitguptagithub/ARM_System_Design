`timescale 1ns/1ps

module hazard_detection_unit_tb;

    // Inputs
    reg clk;
    reg reset;
    reg i_Sig_Memory_Write_Back_Enable;
    reg [3:0] i_Memory_Destination;
    reg i_Sig_Exe_Write_Back_Enable;
    reg [3:0] i_Exe_Destination;
    reg [3:0] i_Src_1;
    reg [3:0] i_Src_2;
    reg i_Two_Src;
    reg i_Sig_Forward_Enable;
    reg i_Sig_Exe_Memory_Read_Enable;

    // Output
    wire o_Sig_Hazard_Detected;

    // Instantiate the Unit Under Test (UUT)
    hazard_detection_unit uut (
        .clk(clk),
        .reset(reset),
        .i_Sig_Memory_Write_Back_Enable(i_Sig_Memory_Write_Back_Enable),
        .i_Memory_Destination(i_Memory_Destination),
        .i_Sig_Exe_Write_Back_Enable(i_Sig_Exe_Write_Back_Enable),
        .i_Exe_Destination(i_Exe_Destination),
        .i_Src_1(i_Src_1),
        .i_Src_2(i_Src_2),
        .i_Two_Src(i_Two_Src),
        .i_Sig_Forward_Enable(i_Sig_Forward_Enable),
        .i_Sig_Exe_Memory_Read_Enable(i_Sig_Exe_Memory_Read_Enable),
        .o_Sig_Hazard_Detected(o_Sig_Hazard_Detected)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        i_Sig_Memory_Write_Back_Enable = 0;
        i_Memory_Destination = 0;
        i_Sig_Exe_Write_Back_Enable = 0;
        i_Exe_Destination = 0;
        i_Src_1 = 0;
        i_Src_2 = 0;
        i_Two_Src = 0;
        i_Sig_Forward_Enable = 0;
        i_Sig_Exe_Memory_Read_Enable = 0;

        // Wait for global reset
        #100;
        reset = 1;
        #10;
        reset = 0;
        #10;

        // Test case 1: No hazard
        i_Sig_Memory_Write_Back_Enable = 1;
        i_Memory_Destination = 4'b0001;
        i_Sig_Exe_Write_Back_Enable = 1;
        i_Exe_Destination = 4'b0010;
        i_Src_1 = 4'b0011;
        i_Src_2 = 4'b0100;
        i_Two_Src = 1;
        i_Sig_Forward_Enable = 0;
        i_Sig_Exe_Memory_Read_Enable = 0;
        #10;
        if (o_Sig_Hazard_Detected !== 0) $display("Test case 1 failed");

        // Test case 2: Hazard without forwarding
        i_Src_1 = 4'b0010;
        #10;
        if (o_Sig_Hazard_Detected !== 1) $display("Test case 2 failed");

        // Test case 3: Hazard with forwarding
        i_Sig_Forward_Enable = 1;
        i_Sig_Exe_Memory_Read_Enable = 0;
        #10;
        if (o_Sig_Hazard_Detected !== 0) $display("Test case 3 failed");

        // Test case 4: Hazard with forwarding and memory read
        i_Sig_Exe_Memory_Read_Enable = 1;
        #10;
        if (o_Sig_Hazard_Detected !== 1) $display("Test case 4 failed");

        // Test case 5: Two-source hazard
        i_Src_1 = 4'b0011;
        i_Src_2 = 4'b0010;
        i_Two_Src = 1;
        #10;
        if (o_Sig_Hazard_Detected !== 1) $display("Test case 5 failed");

        $display("All test cases completed");
        $finish;
    end

endmodule
