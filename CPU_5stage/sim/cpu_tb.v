`timescale 1ns / 1ps

module cpu_tb;

    reg clk;
    reg rst_n;
    
    wire    [31: 0] debug_wb_pc;
    wire            debug_wb_rf_wen;
    wire    [4: 0]  debug_wb_rf_addr;
    wire    [31: 0] debug_wb_rf_wdata;
    wire    [31: 0] current_if_inst, current_id_inst, current_exe_inst, current_mem_inst;
    wire    [1: 0]  forward_signal_a, forward_signal_b;
    wire            pc_en;
    
    cpu u_cpu(
        .clk(clk),
        .rst_n(rst_n),
        
        .debug_wb_pc(debug_wb_pc),
        .debug_wb_rf_wen(debug_wb_rf_wen),
        .debug_wb_rf_addr(debug_wb_rf_addr),
        .debug_wb_rf_wdata(debug_wb_rf_wdata),
        .current_if_inst(current_if_inst), 
        .current_id_inst(current_id_inst), 
        .current_exe_inst(current_exe_inst), 
        .current_mem_inst(current_mem_inst),
        .forward_signal_a(forward_signal_a),
        .forward_signal_b(forward_signal_b),
        .pc_reg_en(pc_en)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        #495
        rst_n = 1;
        
        $display("==============================================================");
        $display("Test begin!");
        $display("==============================================================");
    end
    
    always #5 clk = ~clk;
    
endmodule
