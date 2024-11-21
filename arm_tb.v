`timescale 1ns / 1ps

module arm_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // 10ns clock period

  // Inputs
  reg clk;
  reg reset;

  // Outputs
  wire [31:0] PC;
  wire [31:0] ALU_result;

  // Instantiate the Unit Under Test (UUT)
  arm uut (
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .ALU_result(ALU_result)
  );

  // Clock generation
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;

    // Wait for 100 ns for global reset
    #100;
    reset = 0;

    // Run for several clock cycles
    #(CLK_PERIOD*20);

    // End simulation
    $finish;
  end

  // Monitor
  initial begin
    $monitor("Time=%0t, Reset=%b, PC=%h, ALU_result=%h",
             $time, reset, PC, ALU_result);
  end

endmodule
