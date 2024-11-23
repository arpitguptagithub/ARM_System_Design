`timescale 1ns / 1ps

module tb_top_module;

    // Testbench signals
    reg clk;
    reg reset;
    wire [31:0] result;
    wire [3:0] status;
    wire mem_read;
    wire mem_write;
    wire wb_enable;
    wire status_write;

    // Instantiate the top_module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .result(result),
        .status(status),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wb_enable(wb_enable),
        .status_write(status_write)
    );

    // Clock generation
    initial begin
        clk = 0; // Initialize clock
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1; // Assert reset
        #10; // Wait for 10 time units
        reset = 0; // Deassert reset

        // Wait and observe outputs
        #100; // Run the simulation for 100 time units

        // Finish simulation
        $finish;
    end

    // Monitor outputs in the console
    initial begin
        $monitor("Time: %0t | Result: %h | Status: %b | Mem Read: %b | Mem Write: %b | WB Enable: %b | Status Write: %b", 
                  $time, result, status, mem_read, mem_write, wb_enable, status_write);
    end

endmodule
