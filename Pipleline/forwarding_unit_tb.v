`timescale 1ns/1ps

module forwarding_unit_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg i_Forwarding_Enable;
    reg [3:0] i_Src_1;
    reg [3:0] i_Src_2;
    reg [3:0] i_Write_Back_Destination;
    reg [3:0] i_Memory_Destination;
    reg i_Sig_Write_Back_Write_Back_Enable;
    reg i_Sig_Memory_Write_Back_Enable;

    // Outputs
    wire [1:0] o_Sel_Src_1;
    wire [1:0] o_Sel_Src_2;

    // Instantiate the Unit Under Test (UUT)
    forwarding_unit uut (
        .i_Forwarding_Enable(i_Forwarding_Enable),
        .i_Src_1(i_Src_1),
        .i_Src_2(i_Src_2),
        .i_Write_Back_Destination(i_Write_Back_Destination),
        .i_Memory_Destination(i_Memory_Destination),
        .i_Sig_Write_Back_Write_Back_Enable(i_Sig_Write_Back_Write_Back_Enable),
        .i_Sig_Memory_Write_Back_Enable(i_Sig_Memory_Write_Back_Enable),
        .o_Sel_Src_1(o_Sel_Src_1),
        .o_Sel_Src_2(o_Sel_Src_2)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        i_Forwarding_Enable = 0;
        i_Src_1 = 0;
        i_Src_2 = 0;
        i_Write_Back_Destination = 0;
        i_Memory_Destination = 0;
        i_Sig_Write_Back_Write_Back_Enable = 0;
        i_Sig_Memory_Write_Back_Enable = 0;

        // Wait for a few clock cycles
        #(CLK_PERIOD*2);

        // Test case 1: No forwarding
        i_Forwarding_Enable = 0;
        i_Src_1 = 4'b0001;
        i_Src_2 = 4'b0010;
        i_Write_Back_Destination = 4'b0001;
        i_Memory_Destination = 4'b0010;
        i_Sig_Write_Back_Write_Back_Enable = 1;
        i_Sig_Memory_Write_Back_Enable = 1;
        #CLK_PERIOD;

        // Test case 2: Forwarding from MEM stage
        i_Forwarding_Enable = 1;
        i_Src_1 = 4'b0011;
        i_Src_2 = 4'b0100;
        i_Memory_Destination = 4'b0011;
        i_Sig_Memory_Write_Back_Enable = 1;
        #CLK_PERIOD;

        // Test case 3: Forwarding from WB stage
        i_Src_1 = 4'b0101;
        i_Src_2 = 4'b0110;
        i_Write_Back_Destination = 4'b0110;
        i_Sig_Write_Back_Write_Back_Enable = 1;
        i_Sig_Memory_Write_Back_Enable = 0;
        #CLK_PERIOD;

        // Test case 4: Forwarding from both MEM and WB stages
        i_Src_1 = 4'b0111;
        i_Src_2 = 4'b1000;
        i_Write_Back_Destination = 4'b0111;
        i_Memory_Destination = 4'b1000;
        i_Sig_Write_Back_Write_Back_Enable = 1;
        i_Sig_Memory_Write_Back_Enable = 1;
        #CLK_PERIOD;

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, FWD_EN=%b, Src1=%b, Src2=%b, WB_Dest=%b, MEM_Dest=%b, WB_EN=%b, MEM_EN=%b, Sel_Src1=%b, Sel_Src2=%b",
                 $time, i_Forwarding_Enable, i_Src_1, i_Src_2, i_Write_Back_Destination, i_Memory_Destination,
                 i_Sig_Write_Back_Write_Back_Enable, i_Sig_Memory_Write_Back_Enable, o_Sel_Src_1, o_Sel_Src_2);
    end

endmodule
