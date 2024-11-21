`timescale 1ns / 1ps

module memory_tb;

    reg [31:0] address;
    wire [31:0] instruction;

    // Instantiate the Memory module
    Memory uut (
        .address(address),
        .instruction(instruction)
    );

    // Test procedure
    initial begin
        // Initialize address
        address = 32'd0;

        // Monitor the instruction output
        $monitor("Address: %d, Instruction: %b", address, instruction);

        // Test a range of addresses
        #10 address = 32'd0;   // Test address 0
        #10 address = 32'd1;   // Test address 1
        #10 address = 32'd2;   // Test address 2
        #10 address = 32'd3;   // Test address 3
        #10 address = 32'd4;   // Test address 4
        #10 address = 32'd5;   // Test address 5
        #10 address = 32'd6;   // Test address 6
        #10 address = 32'd7;   // Test address 7
        #10 address = 32'd8;   // Test address 8
        #10 address = 32'd9;   // Test address 9
        #10 address = 32'd10;  // Test address 10
        #10 address = 32'd11;  // Test address 11
        #10 address = 32'd12;  // Test address 12
        #10 address = 32'd13;  // Test address 13
        #10 address = 32'd14;  // Test address 14
        #10 address = 32'd15;  // Test address 15
        #10 address = 32'd16;  // Test address 16
        #10 address = 32'd17;  // Test address 17
        #10 address = 32'd18;  // Test address 18
        #10 address = 32'd19;  // Test address 19
        #10 address = 32'd20;  // Test address 20
        #10 address = 32'd21;  // Test address 21
        #10 address = 32'd22;  // Test address 22
        #10 address = 32'd23;  // Test address 23
        #10 address = 32'd24;  // Test address 24
        #10 address = 32'd25;  // Test address 25
        #10 address = 32'd26;  // Test address 26
        #10 address = 32'd27;  // Test address 27
        #10 address = 32'd28;  // Test address 28
        #10 address = 32'd29;  // Test address 29
        #10 address = 32'd30;  // Test address 30
        #10 address = 32'd31;  // Test address 31
        #10 address = 32'd32;  // Test address 32
        #10 address = 32'd33;  // Test address 33
        #10 address = 32'd34;  // Test address 34
        #10 address = 32'd35;  // Test address 35
        #10 address = 32'd36;  // Test address 36
        #10 address = 32'd37;  // Test address 37
        #10 address = 32'd38;  // Test address 38
        #10 address = 32'd39;  // Test address 39
        #10 address = 32'd40;  // Test address 40
        #10 address = 32'd41;  // Test address 41
        #10 address = 32'd42;  // Test address 42
        #10 address = 32'd43;  // Test address 43
        #10 address = 32'd44;  // Test address 44
        #10 address = 32'd45;  // Test address 45
        #10 address = 32'd46;  // Test address 46
        #10 address = 32'd47;  // Test out of range (default case)

        // End the simulation
        #10 $finish;
    end

endmodule