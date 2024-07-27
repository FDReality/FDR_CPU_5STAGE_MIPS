`timescale 1ns / 1ps


module regfile_tb;
    reg             clk, we, rst_n;
    reg [4 :0]      raddr1, raddr2, waddr;
    reg [31: 0]     wdata;
    
    wire [31: 0]    rdata1, rdata2;
    
    regfile u_regfile(
        .clk(clk),
        .we(we),
        .rst_n(rst_n),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );
    
    initial begin
        clk = 0;
        we = 0;
        rst_n = 0;
        raddr1 = 0;
        raddr2 = 0;
        waddr = 0;
        wdata = 0;
        #20 we = 1;
        #200 rst_n = 1;
    end
    
    always #10 clk = ~clk;
    
    always@ (posedge clk) begin
        raddr1 = ($random) % 10;
        raddr2 = ($random) % 10;
        waddr = ($random) % 10;
        wdata = $random;
    end
    
endmodule
