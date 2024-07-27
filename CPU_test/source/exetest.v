module exetest(
    input            clk, rst_n, mux_sel1, mux_sel2,
    input   [31: 0]  output_data_1, output_data_2, ex_data, npc_addr,
    input   [5: 0]   alu_op,
    
    output           euqal_mov,
    output  [31: 0]  alu_output
);
    
    wire    [31: 0] mux1_output;
    wire    [31: 0] mux2_output;
    
    alu u_alu(
        .alu_op(alu_op),
        .input_data1(mux1_output),
        .input_data2(mux2_output),
        .clk(clk),
        .rst_n(rst_n),
        .output_result(alu_output),
        .equal_mov(euqal_mov)
    );
    
    mux32 mux_1(
        .input_data1(output_data_1),    //rs
        .input_data2(npc_addr),
        .sel(mux_sel1),
        .output_data(mux1_output)
    );

    mux32 mux_2(
        .input_data1(output_data_2),    //rt
        .input_data2(ex_data),
        .sel(mux_sel2),
        .output_data(mux2_output)
    );

endmodule