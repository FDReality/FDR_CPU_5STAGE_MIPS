module wbsel(           //write back select
    input           sel,
    input   [4: 0]  rt_addr,
    input   [4: 0]  rd_addr,
    
    output  [4: 0]  wb_addr
);

    assign wb_addr = (sel == 1) ? rt_addr : rd_addr;

endmodule
