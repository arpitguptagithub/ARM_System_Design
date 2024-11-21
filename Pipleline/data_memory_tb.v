`timescale 1ns / 1ps

module data_memory_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Sig_Memory_Write_Enable;
    reg i_Sig_Memory_Read_Enable;
    reg [DATA_WIDTH - 1:0] i_Address;
    reg [DATA_WIDTH - 1:0] i_Write_Data;

    // Outputs
    wire [DATA_WIDTH - 1:0] o_Read_Data;

    // Instantiate the Unit Under Test (UUT)
    data_memory uut (
        .clk(clk),
        .reset(reset),
        .i_Sig_Memory_Write_Enable(i_Sig_Memory_Write_Enable),
        .i_Sig_Memory_Read_Enable(i_Sig_Memory_Read_Enable),
        .i_Address(i_Address),
        .i_Write_Data(i_Write_Data),
        .o_Read_Data(o_Read_Data)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        i_Sig_Memory_Write_Enable = 0;
        i_Sig_Memory_Read_Enable = 0;
        i_Address = 0;
        i_Write_Data = 0;

        // Wait for 100 ns for global reset
        #100;
        reset = 0;

        // Test case 1: Write data
        i_Sig_Memory_Write_Enable = 1;
        i_Address = 32'd1024; // First address in memory
        i_Write_Data = 32'hDEADBEEF;
        #CLK_PERIOD;
        i_Sig_Memory_Write_Enable = 0;

        // Test case 2: Read data
        i_Sig_Memory_Read_Enable = 1;
        i_Address = 32'd1024;
        #CLK_PERIOD;
        if (o_Read_Data !== 32'hDEADBEEF)
            $display("Error: Read data mismatch. Expected: %h, Got: %h", 32'hDEADBEEF, o_Read_Data);
        else
            $display("Test case 2 passed: Read data matches written data");
        i_Sig_Memory_Read_Enable = 0;

        // Test case 3: Write to a different address
        i_Sig_Memory_Write_Enable = 1;
        i_Address = 32'd1028; // Second word in memory
        i_Write_Data = 32'hCAFEBABE;
        #CLK_PERIOD;
        i_Sig_Memory_Write_Enable = 0;

        // Test case 4: Read from the new address
        i_Sig_Memory_Read_Enable = 1;
        i_Address = 32'd1028;
        #CLK_PERIOD;
        if (o_Read_Data !== 32'hCAFEBABE)
            $display("Error: Read data mismatch. Expected: %h, Got: %h", 32'hCAFEBABE, o_Read_Data);
        else
            $display("Test case 4 passed: Read data matches written data");
        i_Sig_Memory_Read_Enable = 0;

        // Test case 5: Read without read enable
        i_Sig_Memory_Read_Enable = 0;
        i_Address = 32'd1024;
        #CLK_PERIOD;
        if (o_Read_Data !== 32'b0)
            $display("Error: Read data should be 0 when read enable is off. Got: %h", o_Read_Data);
        else
            $display("Test case 5 passed: Read data is 0 when read enable is off");

        // End simulation
        #(CLK_PERIOD*2);
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t, WE=%b, RE=%b, Addr=%h, WData=%h, RData=%h",
                 $time, i_Sig_Memory_Write_Enable, i_Sig_Memory_Read_Enable, i_Address, i_Write_Data, o_Read_Data);
    end

endmodule
