`timescale 1ns / 1ps

module control_unit_tb;

  // Inputs
  reg [6:0] opcode;

  // Outputs
  wire RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch;
  wire [1:0] ALUOp;

  // Instantiate the Unit Under Test (UUT)
  control_unit uut (
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
  );

  initial begin
    // Initialize Inputs
    opcode = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Test R-type instructions
    opcode = 7'b0110011;
    #10;
    if ({RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} !== 8'b10000010)
      $display("Error: R-type instruction failed");

    // Test I-type ALU instructions
    opcode = 7'b0010011;
    #10;
    if ({RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} !== 8'b11000010)
      $display("Error: I-type ALU instruction failed");

    // Test lw instruction
    opcode = 7'b0000011;
    #10;
    if ({RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} !== 8'b11110000)
      $display("Error: lw instruction failed");

    // Test sw instruction
    opcode = 7'b0100011;
    #10;
    if ({RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} !== 8'b01100000)
      $display("Error: sw instruction failed");

    // Test beq instruction
    opcode = 7'b1100011;
    #10;
    if ({RegWrite, ALUSrc, MemWrite, MemRead, MemtoReg, Branch, ALUOp} !== 8'b00001001)
      $display("Error: beq instruction failed");

    $display("Control Unit Testbench completed");
    $finish;
  end

endmodule