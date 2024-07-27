module idtest(
    input           clk, rst_n, we,
    input   [31: 0] current_inst, wb_data,
    input   [4: 0]  wb_addr,
        
    output  [31: 0] output_data_1, output_data_2, ex_data
);

    wire    [31: 0]   imm_ex;
    
    wire    [5: 0]    opcode;
    wire    [4: 0]    rs;
    wire    [4: 0]    rt;
    wire    [4: 0]    rd;
    wire    [10: 0]   funcode;
    wire    [25: 0]   imm;
    
    assign opcode   = current_inst[31: 26];
    assign rs       = current_inst[25: 21];
    assign rt       = current_inst[20: 16];
    assign rd       = current_inst[15: 11];
    assign funcode  = current_inst[10: 0 ];
    assign imm      = current_inst[25: 0 ];
    
    registers u_registers(
        .rs1(rs),
        .rs2(rt),
        .wb_addr(wb_addr),
        .wb_data(wb_data),
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .output_data_1(output_data_1),
        .output_data_2(output_data_2)
    );
    
    extender u_extender(
        .opcode(opcode),
        .input_26bit(imm),
        .output_32bit(imm_ex)
    );
    
    dataholder imm_reg(
        .in(imm_ex),
        .clk(clk),
        .out(ex_data)
    );

endmodule