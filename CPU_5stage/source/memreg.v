module memreg(
    input   [31: 0] data_temp,
    input           clk, rst_n, mem_en,
    input   [31: 0] exe_inst_input, exe_pc_input, alu_output,
    
    output  [31: 0] load_data,
    output  [31: 0] mem_inst, mem_pc, mem_alu_out
);
    
    datareg u_datareg(
        .input_data(data_temp),
        .clk(clk),
        .output_data(load_data)
    );
    
    instreg u_instreg(              //keep inst
        .input_inst(exe_inst_input),
        .ir_en(mem_en),
        .clk(clk),
        .rst_n(rst_n),
        
        .output_inst(mem_inst)
    );
    
    pc u_if_pc(                 //keep pc
        .new_addr(exe_pc_input),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(mem_en),
        .output_pc(mem_pc)
    );
    
    alu_output u_alu_output(        //keep alu_out
        .input_data(alu_output),
        .clk(clk),
        .rst_n(rst_n),
        .output_data(mem_alu_out)
    );
    
endmodule
