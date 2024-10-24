module top_module (
    input wire clk,
    input wire reset,
    output reg [31:0] result,
    output reg [3:0] status,
    output reg mem_read,
    output reg mem_write,
    output reg wb_enable,
    output reg status_write
);

    // Hardcoded values for testing
    localparam [1:0] mode = 2'b01;              // Sample mode
    localparam [3:0] opcode = 4'b0010;          // Sample opcode
    localparam [31:0] val_in = 32'hA5A5A5A5;    // Sample value input
    localparam mem_ins = 1'b1;                   // Sample memory instruction
    localparam immediate = 1'b0;                 // Sample immediate

    // Hardcoded outputs for testing
    localparam [31:0] hardcoded_result = 32'hDEADBEEF; // Sample result
    localparam [3:0] hardcoded_status = 4'b1010;       // Sample status

    wire [3:0] alu_control;
    wire carry_in = 1'b0; // Can be modified based on your design
    wire mem_write_internal;
    wire mem_read_internal;
    wire wb_enable_internal;
    wire status_write_internal;

    // Instantiate the Control Unit
    control_unit CU (
        .i_Opcode(opcode),
        .i_Memory_Ins(mem_ins),
        .i_Immediate(immediate),
        .i_Mode(mode),
        .o_Sigs_Control(alu_control),
        .o_Sig_Memory_Write_Enable(mem_write_internal),
        .o_Sig_Memory_Read_Enable(mem_read_internal),
        .o_Sig_Write_Back_Enable(wb_enable_internal),
        .o_Sig_Status_Write_Enable(status_write_internal)
    );

    // Instantiate the ALU (not used here since we have hardcoded outputs)
    // You can still include this if you want to simulate ALU operations
    wire [31:0] alu_result;
    wire [3:0] alu_status;

    // Logic for handling reset and normal operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 32'b0;
            status <= 4'b0;
            mem_read <= 1'b0;
            mem_write <= 1'b0;
            wb_enable <= 1'b0;
            status_write <= 1'b0;
        end else begin
            // Hardcoded output assignments
            result <= hardcoded_result;
            status <= hardcoded_status;
            mem_read <= 1'b1;      // Sample memory read signal
            mem_write <= 1'b1;     // Sample memory write signal
            wb_enable <= 1'b1;     // Sample write back enable
            status_write <= 1'b1;  // Sample status write enable
        end
    end
    
    always @(posedge clk) begin
        $monitor("Time: %0t | Result: %h | Status: %b | Mem Read: %b | Mem Write: %b | WB Enable: %b | Status Write: %b", 
                  $time, result, status, mem_read, mem_write, wb_enable, status_write);
    end
endmodule