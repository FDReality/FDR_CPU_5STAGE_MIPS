module pcsel(
    input   [31: 0]     jmp_addr,
    input   [31: 0]     pc_addr,
    input               pc_sel,
    
    output  [31: 0]     next_addr
);

    assign next_addr = (pc_sel == 1)? jmp_addr : pc_addr;
    
endmodule