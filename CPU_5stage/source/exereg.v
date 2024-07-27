module exereg(
    input   [31: 0] alu_output, id_inst_input, exe_pc_input,
    input           clk, rst_n, we,
    
    output  [31: 0] exe_out, exe_inst, exe_pc
);
    
    alu_output u_alu_output(
        .input_data(alu_output),
        .clk(clk),
        .rst_n(rst_n),
        .output_data(exe_out)
    );

    instreg u_instreg(              //keep inst
        .input_inst(id_inst_input),
        .ir_en(we),
        .clk(clk),
        .rst_n(rst_n),
        
        .output_inst(exe_inst)
    );
    
    pc u_if_pc(                 //keep pc
        .new_addr(exe_pc_input),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(we),
        .output_pc(exe_pc)
    );
    
endmodule
