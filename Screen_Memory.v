module Screen_Memory(
    input clock,
    input [15:0] address, 
    input [15:0] displayAddr,
    input byteWrite,
    input isWrite,
    input [31:0] writeData,
    output reg [31:0] displayData
);

    (* ram_style = "block" *)
    reg [31:0] memory [2399:0]; // Adjust memory size as per display requirements
    
    initial begin
        $readmemb("display.mem", memory, 0, 2399); // Load initial screen state
    end

    wire [15:0] addr;
    assign addr = address[15:2];  // Simplified to avoid unnecessary OR operation
    
    always @(posedge clock) begin
        if (isWrite && addr < 16'd2400) begin // Ensure writes are within memory bounds
            if (byteWrite == 1'b0) begin
                memory[addr] <= writeData;
            end else begin
                case (address[1:0])
                    2'b00: memory[addr][31:24] <= writeData[7:0];
                    2'b01: memory[addr][23:16] <= writeData[7:0];
                    2'b10: memory[addr][15:8]  <= writeData[7:0];
                    2'b11: memory[addr][7:0]   <= writeData[7:0];
                endcase
            end
        end
    end

    always @(posedge clock) begin
        displayData <= (displayAddr < 16'd2400) ? memory[displayAddr] : 32'd0; // Bounds check for display
    end

endmodule
