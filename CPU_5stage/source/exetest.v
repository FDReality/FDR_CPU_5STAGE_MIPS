module exetest(
    input            rst_n,
    input   [5: 0]   alu_op,
    input   [31: 0]  mux41_input_1, mux41_input_2,
    
    output           euqal_mov,
    output  [31: 0]  alu_output
);
    
    wire    [31: 0] mux_sll_out;
    
    alu u_alu(
        .alu_op(alu_op),
        .input_data1(mux41_input_1),
        .input_data2(mux41_input_2),
        .rst_n(rst_n),
        .output_result(alu_output),
        .equal_mov(euqal_mov)
    );

endmodule