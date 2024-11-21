module tb_instruction_memory;

  // Parameters
  parameter DATA_WIDTH = 32;
  
  // Testbench signals
  reg clk;
  reg reset;
  reg [DATA_WIDTH - 1:0] i_Address;
  wire [DATA_WIDTH - 1:0] o_Instruction;
  
  // Instantiate the DUT (Device Under Test)
  instruction_memory #(DATA_WIDTH) dut (
    .clk(clk),
    .reset(reset),
    .i_Address(i_Address),
    .o_Instruction(o_Instruction)
  );
  
  // Clock Generation (period = 10 time units)
  always #5 clk = ~clk;
  
  // Task to simulate fetching instructions
  task fetch_instruction;
    input [DATA_WIDTH-1:0] address;
    begin
      i_Address = address;
      #10; // Wait for one clock cycle
      $display("Address: %h, Instruction: %b", address, o_Instruction);
    end
  endtask
  
  // Testbench process
  initial begin
    // Initialize signals
    clk = 0;
    reset = 0;
    i_Address = 32'd0;

    // Apply reset
    $display("\nApplying reset...");
    reset = 1;
    #10;
    reset = 0;
    
    // Wait for reset to take effect
    #10;
    
    // Fetch instructions at various addresses
    $display("\nFetching instructions after reset...");
    fetch_instruction(32'd0);   // First instruction (MOV R0, #20)
    
    // You can add more instructions and load them into memory manually in the module to test here.
    // For now, let’s simulate reading other addresses (assumed they might be preloaded in memory)
    
    fetch_instruction(32'd4);   // Fetch second instruction (if any)
    fetch_instruction(32'd8);   // Fetch third instruction (if any)
    fetch_instruction(32'd12);  // Fetch fourth instruction (if any)

    // Further test cases can be added for memory content, edge cases, etc.
    
    #50 $finish; // End the simulation after enough delay
  end
  
  // Dump waveform for debugging
  initial begin
    $dumpfile("instruction_memory.vcd");
    $dumpvars(0, tb_instruction_memory);
  end

endmodule
