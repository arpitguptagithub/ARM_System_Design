`timescale 1ns/1ns

module SRAM (
    input             clk,
    input             rst,
    input             SRAM_WE_N,
    input    [16:0]   SRAM_ADDR, 
    input    [7:0]    key_reg,
    input    [31:0]   displayAddr,
    input             sample,

    output [31:0] displayData,
//    output reg [3:0] led,
    
    inout    [63:0]   SRAM_DQ              
);

    reg [31:0] memory[0:511]; //65535

    assign #30 SRAM_DQ = SRAM_WE_N ? {memory[{SRAM_ADDR[16:1], 1'b1}], memory[{SRAM_ADDR[16:1], 1'b0}]} : 64'bz;

    integer i;

    wire [15:0] displayAddress;
    wire displayIsWrite;

    assign displayAddress = SRAM_ADDR[16:1];
    assign displayIsWrite = (SRAM_ADDR[16:1] < 32'd9600 && SRAM_WE_N == 1'b0 ) ? 1'b1 : 1'b0; //640*480/32=9600

    reg [7:0] keyVal;  //***
    reg dample;
    reg readKeyboard;   ///****
    
    wire [31:0] content;
    
    initial
        begin
//            led <= 4'd0;
            keyVal <= 8'd0;
            dample <= 1'b1;
            readKeyboard <= 1'b0;
        end
    
    always @(posedge clk)
        begin
            if( SRAM_ADDR[16:1] == 18'd206204 )
                begin
                    readKeyboard <= 1'b1;
                    if( sample != dample )
                        begin
                            keyVal <= key_reg;
                            dample <= sample;
//                            led <= 4'b1111;
                        end
                    else
                        keyVal <= 8'd0;
                end
            else
                readKeyboard <= 1'b0;
        end
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 512; i = i + 1)
                memory [i] <= 32'b0;
        end
        else if (~SRAM_WE_N) begin
            memory[SRAM_ADDR] <= (readKeyboard == 1'b1) ? keyVal :
                                (SRAM_ADDR[16:1] < 32'd9600) ? content : 
                                SRAM_DQ[31:0];
        end
    end

    Screen_Memory disMem (
        .clock(clk),  //correct
        .address(displayAddress),   
        .displayAddr(displayAddr[15:0]),  //corrrect
        .byteWrite(SRAM_WE_N),      //correct
        .isWrite(displayIsWrite),              
        .writeData(SRAM_DQ[31:0]),      //correct
        .content(content),          //correct
        .displayData(displayData)   //correct
    );

endmodule
