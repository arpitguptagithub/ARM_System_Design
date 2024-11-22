`timescale 1ns/1ns

module ARM_TB;
    reg clk = 0;
    reg sram_clk = 1;
    reg rst;
    reg sram_rst;
    reg isForwardingActive;
    wire SRAM_WE_N;
    wire [16:0] SRAM_ADDR;
    wire [63:0] SRAM_DQ;

    // // Monitor variables
    // reg [31:0] monitored_mem_value;
    // reg [16:0] monitor_address = 17'h0_0100;

    // Register monitoring
    wire [31:0] R0_value;
    wire [31:0] R1_value;
    wire [31:0] R2_value;
    wire [31:0] R3_value;
    wire [31:0] R4_value;
    wire [31:0] R5_value;
    wire [31:0] R6_value;
    wire [31:0] R7_value;
    
    // Status register monitoring
    wire [3:0] status_bits;  // N Z C V flags

    ARM CPU(
        .clk(clk),
        .rst(rst),
        .isForwardingActive(isForwardingActive),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
    );
    
    // Connect register monitoring signals
    assign R0_value = CPU.id_stage.register_file.registers[0];
    assign R1_value = CPU.id_stage.register_file.registers[1];
    assign R2_value = CPU.id_stage.register_file.registers[2];
    assign R3_value = CPU.id_stage.register_file.registers[3];
    assign R4_value = CPU.id_stage.register_file.registers[4];
    assign R5_value = CPU.id_stage.register_file.registers[5];
    assign R6_value = CPU.id_stage.register_file.registers[6];
    assign R7_value = CPU.id_stage.register_file.registers[7];
    
    // Connect status register monitoring
    assign status_bits = CPU.status_register.status_out;

    SRAM sram (
        .clk(sram_clk),
        .rst(sram_rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
    );

    always #10 clk = ~clk;
    always #20 sram_clk = ~sram_clk;
    
    // // Monitor memory writes
    always @(SRAM_ADDR or SRAM_DQ or SRAM_WE_N) begin
        if (!SRAM_WE_N) begin
            $display("Time=%0t ns: Memory Write at Address %b = %b", 
                    $time, SRAM_ADDR, SRAM_DQ[31:0]);
        end
    end
    always @(SRAM_ADDR or SRAM_DQ or SRAM_WE_N) begin
    if (SRAM_WE_N) begin  // Read operation
        $display("Time=%0t ns: Memory Read at Address %b", 
                $time, SRAM_ADDR);
        end
    end

    always @(posedge clk) begin
    if (!rst) begin
        $display("Time=%0t ns: MEM Stage Address Value = %b", 
                $time, CPU.mem_stage.ALU_res);  // Changed to ALU_res
        $display("Time=%0t ns: MEM Stage Calculated Address = %b", 
                $time, CPU.mem_stage.SRAM_ADDR_Out);  // Changed to SRAM_ADDR_Out
        end
    end

    // Monitor registers on every clock edge
    always @(posedge clk) begin
        if (!rst) begin  // Only display when not in reset
            $display("\nTime=%0t ns: Register Values:", $time);
            $display("R0 = %b", R0_value);
            $display("R1 = %b", R1_value);
            $display("R2 = %b", R2_value);
            $display("R3 = %b", R3_value);
            $display("R4 = %b", R4_value);
            $display("R5 = %b", R5_value);
            $display("R6 = %b", R6_value);
            $display("R7 = %b", R7_value);
            $display("Status Flags (NZCV) = %b", status_bits);
            $display("----------------------------------------");
        end
    end

    // Monitor current instruction
    always @(posedge clk) begin
        if (!rst) begin
            $display("Time=%0t ns: Current Instruction = %b", 
                    $time, CPU.IF_stage_instruction_out);
        end
    end
    
    initial begin
        // Test case setup
        $display("Starting ARM CPU Test");
        $display("----------------------------------------");
        
        // Initialize
        rst = 1;
        sram_rst = 1;
        isForwardingActive = 1;
        
        // Reset period
        #30;
        rst = 0;
        sram_rst = 0;
        
        // Run simulation
        #15000;
        
        // Final state display
        $display("\nFinal CPU State:");
        $display("----------------------------------------");
        $display("Register Values:");
        $display("R0 = %b", R0_value);
        $display("R1 = %b", R1_value);
        $display("R2 = %b", R2_value);
        $display("R3 = %b", R3_value);
        $display("R4 = %b", R4_value);
        $display("R5 = %b", R5_value);
        $display("R6 = %b", R6_value);
        $display("R7 = %b", R7_value);
        $display("Status Flags (NZCV) = %b", status_bits);
        // $display("Memory at 0x%h = 0x%h", monitor_address, monitored_mem_value);
        $display("----------------------------------------");
        
        $stop;
    end
    
    // Optional: Add waveform dumping for GTKWave or similar
    initial begin
        $dumpfile("arm_test.vcd");
        $dumpvars(0, ARM_TB);
    end
    
endmodule