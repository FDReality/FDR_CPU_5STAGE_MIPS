`timescale 1ns / 1ps

module pc(
    input   [31 :0]     new_addr,
    input               clk,
    input               rst_n,
    input               pc_en,
    
    output reg [31: 0]  output_pc
);
    
    always@ (posedge clk) begin
        if(!rst_n)
            output_pc <= 0 - 4;
        else
            output_pc <= (pc_en == 1)? new_addr : output_pc;
    end
    
endmodule
