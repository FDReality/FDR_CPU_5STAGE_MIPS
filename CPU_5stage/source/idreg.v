module idreg(
    input           clk, rst_n, write_en,
    input   [31: 0] if_inst_input, if_pc_input, npc_input,
    
    output  [31: 0] id_inst, id_pc, npc_output
);
    
    instreg u_instreg(
        .input_inst(if_inst_input),
        .ir_en(write_en),
        .clk(clk),
        .rst_n(rst_n),
        
        .output_inst(id_inst)
    );
    
    pc u_if_pc(                            //program count
        .new_addr(if_pc_input),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(write_en),
        .output_pc(id_pc)
    );
    
    npc u_npc(
        .input_addr(npc_input),
        .clk(clk),
        .rst_n(rst_n),
        .npc_en(write_en),
        
        .output_addr(npc_output)
    );
    
endmodule