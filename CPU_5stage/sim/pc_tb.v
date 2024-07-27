`timescale 1ns / 1ps


module pc_tb;

    reg   [31 :0]     new_addr;
    reg               clk;
    reg               rst_n;
    reg               pc_en;
    
    wire [31: 0]  output_pc;
    
    pc u_pc(
        .new_addr(new_addr),
        .clk(clk),
        .rst_n(rst_n),
        .pc_en(pc_en),
        .output_pc(output_pc)
    );
    
    initial begin
        new_addr = 0;
        clk = 0;
        rst_n = 0;
        pc_en = 0;
        #100 rst_n = 1;
        #100 pc_en = 1;
    end
    
    always #10 clk = ~clk;
    
    always@ (posedge clk) begin
        new_addr = ($random) % 20;
    end

endmodule
