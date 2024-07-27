`timescale 1ns / 1ps


module imem_tb;

    reg     [31: 0] addr;
    
    wire    [31: 0] output_inst;
    
    imem u_imem(
        .addr(addr),
        .output_inst(output_inst)
    );
    
    initial begin
        addr = 0;
        
        #10
        
        addr = 32'h00000004;
        
        #10
        
        addr = 32'h00000008;
        
        #10
        
        addr = 32'h00000050;
    end

endmodule
