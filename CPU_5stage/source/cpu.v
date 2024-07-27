`timescale 1ns / 1ps

module cpu(
    input           clk,
    input           rst_n,
    
    output  [31:0]  debug_wb_pc,
    output          debug_wb_rf_wen,
    output  [4:0]   debug_wb_rf_addr,
    output  [31:0]  debug_wb_rf_wdata,
    output  [31:0]  current_if_inst, current_id_inst, current_exe_inst, current_mem_inst,
    output  [1: 0]  forward_signal_a, forward_signal_b,
    output          pc_reg_en
);
    //if
    wire            pc_sel;
    wire            if_id_wen;
    wire    [31: 0] jmp_addr;
    wire    [31: 0] fetch_inst;
    wire    [31: 0] npc_input;
    wire    [31: 0] output_pc;
    wire    [31: 0] inst_to_id;
    wire    [31: 0] npc_output;
    wire    [31: 0] npc_output_if;
    wire    [31: 0] if_pc;
    //id
    wire            reg_wen;
    wire            id_ex_wen;
    wire    [31: 0] wb_data;
    wire    [31: 0] pc_sel_out;
    wire    [4: 0]  wb_addr;
    wire    [31: 0] reg_output_data_1;
    wire    [31: 0] reg_output_data_2;
    wire    [31: 0] extend_data;
    wire    [5: 0]  op_code;
    wire    [10: 0] func_code;
    wire    [31: 0] id_output_data_1;
    wire    [31: 0] id_output_data_2;
    wire    [31: 0] ex_data;
    wire    [31: 0] id_inst;
    wire    [31: 0] id_pc;
    wire    [31: 0] inst_to_exe;
    wire    [31: 0] npc_output_id;
    //exe
    wire            mux_sel1;
    wire            mux_sel2;
    wire    [31: 0] alu_output_1;
    wire    [5: 0]  alu_op;
    wire            equal;
    wire            exe_wen;
    wire    [31: 0] alu_out;
    wire    [31: 0] exe_out;
    wire    [31: 0] exe_inst;
    wire    [31: 0] inst_to_mem;
    wire    [31: 0] exe_pc;
    wire    [31: 0] wb_rt;
    //ma
    wire            mem_en;             //different from mem_wen
    wire            mux_sel_dmem;
    wire    [31: 0] ma_data;
    wire    [31: 0] load_data;
    wire    [31: 0] mem_inst;
    wire    [31: 0] mem_pc;
    wire    [31: 0] mem_alu_out;

    //wb
    wire            wb_sel_wen;
    // forwarding unit
    wire    [31: 0] mux41_output_1;
    wire    [31: 0] mux41_output_2;
    wire            id_ex_rstn;
    wire            data_hazard_id_ex_rstn;
    // branch predictor
    wire            bp_wen;
    wire            if_id_rstn;
    wire            logic_hazard_id_ex_rstn;
    wire            exe_pc_sel;
    wire            exe_reg_rst_n;
    
    assign debug_wb_pc = output_pc;
    assign debug_wb_rf_wen = reg_wen;
    assign debug_wb_rf_addr = wb_addr;
    assign debug_wb_rf_wdata = wb_data;
    assign current_if_inst = inst_to_id;
    assign current_id_inst = id_inst;
    assign current_exe_inst = exe_inst;
    assign current_mem_inst = mem_inst;
    assign pc_reg_en = pc_sel;
    
    iftest u_if(
        .clk(clk), 
        .rst_n(rst_n), 
        .pc_sel(pc_sel),  //need to be modified at bp
        .pc_en(pc_en), 
        .jmp_addr(jmp_addr),
        
        .fetch_inst(fetch_inst),
        .npc_input(npc_input),
        .output_pc(output_pc)
    );
    
    ifreg u_ifreg(
        .fetch_inst(fetch_inst),
        .npc_input(npc_input),
        .pc_input(output_pc),
        .clk(clk),
        .rst_n(if_id_rstn),
        .write_en(if_id_wen),
        
        .inst_to_id(inst_to_id),
        .npc_output(npc_output_if),
        .pc_output(if_pc)
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
        .ex_data(ex_data)
    );
    
    idreg u_idreg(
        .clk(clk),
        .rst_n(id_ex_rstn),
        .write_en(id_ex_wen),
        .if_inst_input(inst_to_id),
        .if_pc_input(if_pc),
        .npc_input(npc_output_if),
        
        .id_inst(id_inst),
        .id_pc(id_pc),
        .npc_output(npc_output_id)
    );
    
    idcontrol id_control(
        .if_inst_input(inst_to_id),
        .clk(clk),
        .rst_n(id_ex_rstn),
        
        .mux_sel_sll(mux_sel_sll),
        .mux_sel1(mux_sel1),
        .mux_sel2(mux_sel2),
        .alu_op(alu_op)
    );

    exetest u_exe(
        .rst_n(rst_n),
        .alu_op(alu_op),
        .mux41_input_1(mux41_output_1),
        .mux41_input_2(mux41_output_2),
        
        .euqal_mov(equal),
        .alu_output(alu_out)
    );
    
    exereg u_exereg(
        .alu_output(alu_out),
        .id_inst_input(id_inst),
        .exe_pc_input(id_pc),
        .clk(clk), 
        .rst_n(exe_reg_rst_n),
        .we(exe_wen),
    
        .exe_out(exe_out),
        .exe_inst(exe_inst),
        .exe_pc(exe_pc)
    );
    
    exe_control exe_control(
        .alu_op(alu_op),    //op_code
        .clk(clk),
        .rst_n(exe_reg_rst_n),
        .mem_rt(reg_output_data_2),
        .equal(equal),
        
        .mem_wen(mem_wen),
        .bp_wen(bp_wen),
        .exe_pc_sel(exe_pc_sel),
        .wb_rt(wb_rt)
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
        .rst_n(rst_n),
        .mem_en(mem_en),
        .exe_inst_input(exe_inst),
        .exe_pc_input(exe_pc),
        .alu_output(exe_out),
        
        .load_data(load_data),
        .mem_inst(mem_inst),
        .mem_pc(mem_pc),
        .mem_alu_out(mem_alu_out)
    );
    
    memcontrol mem_control(
        .exe_inst(exe_inst),
        .clk(clk),
        .rst_n(rst_n),
        .wb_rt(wb_rt),
        
        .wb_sel_wen(wb_sel_wen),
        .dmem_sel(mux_sel_dmem),
        .reg_wen(reg_wen)
    );
       
    wbtest u_wb(
        .mux_sel_dmem(mux_sel_dmem),
        .wb_addr_sel(wb_sel_wen),
        .alu_result(mem_alu_out),
        .load_data(load_data),
        .wb_inst(mem_inst),
        
        .wb_data(wb_data),
        .wb_addr(wb_addr)
    );
    
    controlunit u_control(
        .clk(clk),
        .rst_n(rst_n),
        
        .id_ex_wen(id_ex_wen),
        .exe_wen(exe_wen),
        .mem_en(mem_en),
        .pipe_state(state)
    );
    
    forwarding_unit forwarding_unit(
        .if_inst(inst_to_id),
        .id_inst(id_inst),
        .exe_inst(exe_inst),
        .mem_inst(mem_inst),
        .mem_rt_data(reg_output_data_2),
        .wb_rt_data(wb_rt),
        .alu_out(exe_out),
        .wb_out(wb_data),
        .npc_addr(npc_output_id),
        .rs_output_data(reg_output_data_1),
        .rt_output_data(reg_output_data_2),
        .ex_data(ex_data),
        .mux_sel_sll(mux_sel_sll),
        .mux_sel1(mux_sel1),
        .mux_sel2(mux_sel2),

        .pc_en(pc_en),
        .if_id_en(if_id_wen),
        .id_ex_rstn(data_hazard_id_ex_rstn),
        .exe_forward_data(mux41_output_1),
        .wb_forward_data(mux41_output_2),
        .forward_signal_a(forward_signal_a),
        .forward_signal_b(forward_signal_b)
    );
    
    branch_predictor u_bp(
        .clk(clk),
        .rst_n(rst_n),
        .bp_wen(bp_wen),
        .exe_pc_sel(exe_pc_sel),
        .write_inst_pc(exe_pc),
        .write_inst_jmp_addr(exe_out),
        .read_inst_pc(output_pc),
        
        .jmp_addr(jmp_addr),
        .pc_sel(pc_sel),
        .if_id_rstn(if_id_rstn),
        .id_exe_rstn(logic_hazard_id_ex_rstn),
        .exe_mem_rstn(exe_reg_rst_n)
    );

    mux1bit mux_pc_sel(
        .input_data1(logic_hazard_id_ex_rstn),
        .input_data2(data_hazard_id_ex_rstn),
        .sel(bp_wen),
    
        .output_data(id_ex_rstn)
    );    

endmodule