`timescale 1ns / 1ps

module iftest_tb;

    reg          clk;       //clock
    reg          rst_n;     //reset
    reg          pc_sel;    //select jmp or byorder
    reg          pc_en;     //enable pc
    reg          ir_en;     //enable instreg
    reg  [31: 0] jmp_addr;  //simulate a jmp addr
    
    wire [31: 0] fetch_inst;

    iftest u_iftest(
        .clk(clk), 
        .rst_n(rst_n), 
        .pc_sel(pc_sel), 
        .pc_en(pc_en), 
        .ir_en(ir_en),
        .jmp_addr(jmp_addr),
        .fetch_inst(fetch_inst)
    );
    
    initial begin
        clk = 0;
        rst_n = 0;
        pc_sel = 0;
        pc_en = 0;
        ir_en = 0;
        jmp_addr = 0;
    end
    
    always #10 clk = ~clk;
    
    initial begin
        #20
        rst_n = 1;
        pc_en = 1;
        ir_en = 1;
        
        #295
        jmp_addr = 32'h00000004;
        pc_sel = 1;
        
        #20
        jmp_addr = 32'h00000024;
        
        #20
        jmp_addr = 32'h00000040;
        
    end

endmodule