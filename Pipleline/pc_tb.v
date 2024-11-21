`timescale 1ns / 1ps

module pc_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 10ns clock period

    // Inputs
    reg clk;
    reg reset;
    reg i_Load;
    reg [DATA_WIDTH-1:0] i_PC;

    // Outputs
    wire [DATA_WIDTH-1:0] o_PC;

    // Instantiate the Unit Under Test (UUT)
    pc #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .i_Load(i_Load),
        .i_PC(i_PC),
        .o_PC(o_PC)
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
        i_Load = 0;
        i_PC = 32'h0;

        // Wait for global reset
        #(CLK_PERIOD*2);
        reset = 0;

        // Test case 1: Load new PC value
        #CLK_PERIOD;
        i_Load = 1;
        i_PC = 32'h1000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h1000_0000) $display("Error: PC not loaded correctly");

        // Test case 2: Hold PC value when i_Load is low
        i_Load = 0;
        i_PC = 32'h2000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h1000_0000) $display("Error: PC changed when i_Load is low");

        // Test case 3: Load another PC value
        i_Load = 1;
        i_PC = 32'h3000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h3000_0000) $display("Error: PC not updated to new value");

        // Test case 4: Reset
        reset = 1;
        #CLK_PERIOD;
        if (o_PC !== 32'h0) $display("Error: PC not reset to 0");

        // Test case 5: Load after reset
        reset = 0;
        i_Load = 1;
        i_PC = 32'h4000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h4000_0000) $display("Error: PC not loaded after reset");

        // Test case 6: Multiple consecutive loads
        i_Load = 1;
        i_PC = 32'h5000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h5000_0000) $display("Error: PC not loaded correctly in consecutive load 1");

        i_PC = 32'h6000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h6000_0000) $display("Error: PC not loaded correctly in consecutive load 2");

        i_PC = 32'h7000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h7000_0000) $display("Error: PC not loaded correctly in consecutive load 3");

        // Test case 7: Alternating load and hold
        i_Load = 0;
        #CLK_PERIOD;
        if (o_PC !== 32'h7000_0000) $display("Error: PC changed when i_Load is low after multiple loads");

        i_Load = 1;
        i_PC = 32'h8000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h8000_0000) $display("Error: PC not loaded correctly after alternating load");

        i_Load = 0;
        #CLK_PERIOD;
        if (o_PC !== 32'h8000_0000) $display("Error: PC changed when i_Load is low in alternating pattern");

        // Test case 8: Reset during load
        i_Load = 1;
        i_PC = 32'h9000_0000;
        reset = 1;
        #CLK_PERIOD;
        if (o_PC !== 32'h0) $display("Error: Reset not prioritized over load");

        // Test case 9: Load immediately after reset
        reset = 0;
        i_PC = 32'hA000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'hA000_0000) $display("Error: PC not loaded correctly immediately after reset");

        // Test case 10: Load with maximum value
        i_PC = 32'hFFFF_FFFF;
        #CLK_PERIOD;
        if (o_PC !== 32'hFFFF_FFFF) $display("Error: PC not loaded correctly with maximum value");

        // Test case 11: Load with minimum value
        i_PC = 32'h0000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h0000_0000) $display("Error: PC not loaded correctly with minimum value");

        // Test case 12: Rapid toggling of i_Load
        i_Load = 0;
        i_PC = 32'hB000_0000;
        #(CLK_PERIOD/2);
        i_Load = 1;
        #(CLK_PERIOD/2);
        if (o_PC !== 32'hB000_0000) $display("Error: PC not loaded correctly with rapid i_Load toggle");

        // Test case 13: Hold during multiple clock cycles
        i_Load = 0;
        #(CLK_PERIOD*3);
        if (o_PC !== 32'hB000_0000) $display("Error: PC changed during extended hold");

        // Test case 14: Reset and load on same clock cycle
        reset = 1;
        i_Load = 1;
        i_PC = 32'hC000_0000;
        #CLK_PERIOD;
        if (o_PC !== 32'h0) $display("Error: Reset not prioritized when reset and load occur simultaneously");

        // Test case 15: Load after simultaneous reset and load
        reset = 0;
        #CLK_PERIOD;
        if (o_PC !== 32'hC000_0000) $display("Error: PC not loaded correctly after simultaneous reset and load");

        // End simulation
        #(CLK_PERIOD*2);
        $display("PC Testbench completed");
        $finish;
    end

endmodule
