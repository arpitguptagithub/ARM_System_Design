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