`timescale 1ns / 1ps

module cpu(
    input           clk,
    input           rst_n,
    
    output  [31:0]  debug_wb_pc,
    output          debug_wb_rf_wen,
    output  [4:0]   debug_wb_rf_addr,
    output  [31:0]  debug_wb_rf_wdata,
    output  [31:0]  current_inst,
    output  [9: 0]  state
);
    //if
    wire            pc_sel;
    wire            pc_en;
    wire            ir_en;
    wire    [31: 0] jmp_addr;
    wire    [31: 0] fetch_inst;
    wire    [31: 0] npc_input;
    wire    [31: 0] output_pc;
    wire    [31: 0] inst_to_id;
    wire    [31: 0] npc_output;
    //id
    wire            reg_wen;
    wire            npc_en;
    wire    [31: 0] wb_data;
    wire    [31: 0] pc_sel_out;
    wire    [4: 0]  wb_addr;
    wire    [31: 0] reg_output_data_1;
    wire    [31: 0] reg_output_data_2;
    wire    [31: 0] extend_data;
    wire    [4: 0]  rt_addr;
    wire    [4: 0]  rd_addr;
    wire    [5: 0]  op_code;
    wire    [10: 0] func_code;
    wire    [31: 0] id_output_data_1;
    wire    [31: 0] id_output_data_2;
    wire    [31: 0] ex_data;
    //exe
    wire            mux_sel1;
    wire            mux_sel2;
    wire    [31: 0] alu_output_1;
    wire    [5: 0]  alu_op;
    wire            equal;
    wire    [31: 0] alu_out;
    wire    [31: 0] exe_out;
    //ma
    wire            mem_wen;
    wire            mux_sel_dmem;
    wire    [31: 0] ma_data;
    wire    [31: 0] load_data;
    //wb
    wire            wb_sel_wen;
    
    assign debug_wb_pc = output_pc;
    assign debug_wb_rf_wen = reg_wen;
    assign debug_wb_rf_addr = wb_addr;
    assign debug_wb_rf_wdata = wb_data;
    assign current_inst = fetch_inst;

    iftest u_if(
        .clk(clk), 
        .rst_n(rst_n), 
        .pc_sel(pc_sel), 
        .pc_en(pc_en), 
        .jmp_addr(alu_out),
        
        .fetch_inst(fetch_inst),
        .npc_input(npc_input),
        .output_pc(output_pc)
    );
    
    ifreg u_ifreg(
        .fetch_inst(fetch_inst),
        .npc_input(npc_input),
        .clk(clk),
        .rst_n(rst_n),
        .ir_en(ir_en),
        .npc_en(npc_en),
        
        .inst_to_id(inst_to_id),
        .npc_output(npc_output)
    );

    idtest u_id(
        .clk(clk),
        .rst_n(rst_n),
        .we(reg_wen),        //reg write enable
        .current_inst(inst_to_id),
        .wb_data(wb_data),
        .wb_addr(wb_addr),
        
        .output_data_1(reg_output_data_1),
        .output_data_2(reg_output_data_2),
        .ex_data(extend_data),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .op_code(op_code),
        .func_code(func_code)
    );
    
    idreg u_idreg(
        .clk(clk),
        .data_reg_1(reg_output_data_1),
        .data_reg_2(reg_output_data_2),
        .imm_ex(extend_data),
        
        .output_data_1(id_output_data_1),
        .output_data_2(id_output_data_2),
        .ex_data(ex_data)
    );

    exetest u_exe(
        .clk(clk),
        .rst_n(rst_n),
        .mux_sel1(mux_sel1),
        .mux_sel2(mux_sel2),
        .output_data_1(id_output_data_1),
        .output_data_2(id_output_data_2),
        .ex_data(ex_data),
        .npc_addr(npc_output),
        .alu_op(alu_op),
        
        .euqal_mov(equal),
        .alu_output(alu_out)
    );
    
    exereg u_exereg(
        .alu_output(alu_out),
        .clk(clk), 
        .rst_n(rst_n),
    
        .exe_out(exe_out)
    ); 

    matest u_memacc(
        .clk(clk),
        .rst_n(rst_n),
        .mem_wen(mem_wen),
        .alu_result(exe_out),
        .rt_data(reg_output_data_2),
        
        .load_data(ma_data)
    );
    
    memreg u_memreg(
        .data_temp(ma_data),
        .clk(clk),
        
        .load_data(load_data)
    );
       
    wbtest u_wb(
        .mux_sel_dmem(mux_sel_dmem),
        .wb_addr_sel(wb_sel_wen),
        .alu_result(exe_out),
        .load_data(load_data),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        
        .wb_data(wb_data),
        .wb_addr(wb_addr)
    );
    
    controlunit u_control(
        .opcode(op_code),
        .alu_funcode(func_code),
        .clk(clk),
        .rst_n(rst_n),
        .equal(equal),
        .rt_data(reg_output_data_2),
        
        .pc_en(pc_en),
        .pc_sel(pc_sel),
        .npc_en(npc_en),
        .ir_en(ir_en),
        .reg_wen(reg_wen),
        .mem_wen(mem_wen),
        .wb_sel_wen(wb_sel_wen),
        .mux1_sel(mux_sel1),
        .mux2_sel(mux_sel2),
        .dmem_sel(mux_sel_dmem),
        .alu_op(alu_op),
        .pipe_state(state)
    );

endmodule
