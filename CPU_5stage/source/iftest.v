`timescale 1ns / 1ps

module iftest(                          //fetch instruction test
    input           clk, rst_n, pc_sel, pc_en,
    input   [31: 0] jmp_addr,
    
    output  [31: 0] fetch_inst, npc_input, output_pc
);

    wire    [31: 0] new_addr;
    wire    [31: 0] output_inst;
    wire    [31: 0] pc_addr;
    wire    [31: 0] npc_addr;

    assign npc_input = new_addr;

    imem u_imem(                        //instruction memory
        .addr(output_pc),
        .output_inst(fetch_inst)
    );
    
    pc u_pc(                            //program count
        .new_addr(new_addr),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(pc_en),
        .output_pc(output_pc)
    );
    
    add u_add(
        .index1(output_pc),
        .index2(32'h00000004),
        .result(pc_addr)
    );

    pcsel u_pcsel(
        .jmp_addr(jmp_addr),
        .pc_addr(pc_addr),
        .pc_sel(pc_sel),
    
        .next_addr(new_addr)
    );
   
endmodule
