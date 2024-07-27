module matest(
    input           clk, rst_n, mem_wen,
    input   [31: 0] alu_result, rt_data,
    
    output  [31: 0] load_data
);

    dmem u_dmem(
        .alu_addr(alu_result),
        .data(rt_data),
        .we(mem_wen),
        .clk(clk),
        .rst_n(rst_n),
        .output_data(load_data)
    );

endmodule
