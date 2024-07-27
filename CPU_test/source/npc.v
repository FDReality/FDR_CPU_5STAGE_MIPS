module npc(
    input   [31 :0]     input_addr,
    input               clk,
    input               rst_n,
    input               npc_en,
    
    output reg [31: 0]  output_addr
);
    
    always@ (posedge clk) begin
        if(!rst_n)
            output_addr <= 0;
        else
            output_addr <= (npc_en == 1)? input_addr : output_addr;
    end
    
endmodule
