`timescale 1ns/1ns

module SRAM (
    input             clk,
    input             rst,
    input             SRAM_WE_N,
    input    [16:0]   SRAM_ADDR, 
    inout    [63:0]   SRAM_DQ              
);

    reg [31:0] memory[0:511]; // 512 x 32-bit memory
    reg [63:0] SRAM_DQ_out;

    // Drive SRAM_DQ only when not writing
    assign SRAM_DQ = (SRAM_WE_N) ? SRAM_DQ_out : 64'bz; 

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1)
                memory[i] <= 32'b0;
            $display("SRAM reset: All memory cleared.");
        end else begin
            if (~SRAM_WE_N) begin
                // Write data into memory
                memory[SRAM_ADDR[16:1]] <= SRAM_DQ[31:0]; // Store lower half
                memory[SRAM_ADDR[16:1] + 1] <= SRAM_DQ[63:32]; // Store upper half
                $display("Write to address %d: Data = %h", SRAM_ADDR[16:1], SRAM_DQ);
            end else begin
                // Read data from memory
                SRAM_DQ_out <= {memory[SRAM_ADDR[16:1] + 1], memory[SRAM_ADDR[16:1]]};
                $display("Read from address %d: Data = %h", SRAM_ADDR[16:1], SRAM_DQ_out);
            end
        end
    end

endmodule

module SRAM_TB;

    reg clk;
    reg rst;
    reg SRAM_WE_N;
    reg [16:0] addr;
    reg [63:0] data_in;      // Register for input data during write
    wire [63:0] data;        // Wire for inout data (SRAM_DQ)

    // Instantiate the SRAM module
    SRAM uut (
        .clk(clk),
        .rst(rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(addr),
        .SRAM_DQ(data)
    );

    // Drive data for write operations
    assign data = (~SRAM_WE_N) ? data_in : 64'bz;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst = 1;
        SRAM_WE_N = 1; // Start with write disabled
        addr = 17'b0;

        // Wait for reset to take effect
        #10;

        // Release reset
        rst = 0;
        #10;

        // Write to address 0
        addr = 17'b0;
        data_in = 64'h0000000000000001; // Writing 1 to address 0
        SRAM_WE_N = 0;                  // Enable write
        #10;                            // Wait for write operation to complete

        // Write to address 2 (next address is address 1)
        addr = 17'b10;
        data_in = 64'h0000000000000002; // Writing 2 to address 2
        #10;                            // Wait for write operation to complete

        // Disable write for reading
        SRAM_WE_N = 1;

        // Read from address 0 (should read both addresses)
        addr = 17'b0;
        #10;                            // Wait for read operation to complete

        // Check output for address 0 and address 2 (lower half and upper half)
        if (data[31:0] !== 32'h00000001) 
            $display("Error: Address 0 did not return expected value. Expected: %h, Got: %h", 
                      32'h00000001, data[31:0]);
        
        if (data[63:32] !== 32'h00000002) 
            $display("Error: Address 2 did not return expected value. Expected: %h, Got: %h", 
                      32'h00000002, data[63:32]);

        // End simulation after a short delay for observation purposes
        #10;
        
        $finish;
    end

endmodule