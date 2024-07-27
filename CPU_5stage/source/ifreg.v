module ifreg(
    input   [31: 0] fetch_inst, npc_input, pc_input,
    input           clk, rst_n, write_en,
    
    output  [31: 0] inst_to_id,
    output  [31: 0] npc_output, pc_output
);

    instreg u_instreg(
        .input_inst(fetch_inst),
        .ir_en(write_en),
        .clk(clk),
        .rst_n(rst_n),
        
        .output_inst(inst_to_id)
    );

    npc u_npc(
        .input_addr(npc_input),
        .clk(clk),
        .rst_n(rst_n),
        .npc_en(write_en),
        
        .output_addr(npc_output)
    );
    
    pc u_if_pc(                            //program count
        .new_addr(pc_input),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(write_en),
        .output_pc(pc_output)
    );

endmodule
