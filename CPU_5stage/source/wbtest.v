module wbtest(
    input           mux_sel_dmem, wb_addr_sel,
    input   [31: 0] alu_result, load_data,
    input   [31: 0] wb_inst,
    
    output  [31: 0] wb_data,
    output  [4: 0]  wb_addr
);
    
    wire [4: 0]  rt_addr;
    wire [4: 0]  rd_addr;
    
    assign rt_addr = wb_inst[20: 16];
    assign rd_addr = wb_inst[15: 11];
    
    mux32 mux_dmem(
        .input_data1(alu_result),
        .input_data2(load_data),
        .sel(mux_sel_dmem),
        
        .output_data(wb_data)
    );
    
    wbsel u_wbsel(
        .sel(wb_addr_sel),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
    
        .wb_addr(wb_addr)
    );
    
endmodule
