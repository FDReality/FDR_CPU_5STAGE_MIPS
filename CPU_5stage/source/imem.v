`timescale 1ns / 1ps
`include "cpu.vh"

module imem(        //enter addr fetch inst
    input [31: 0]   addr,
    
    output[31: 0]   output_inst
);

    reg [31: 0] data[255: 0];      //256¡Á32 inst mem
    
    initial begin
        $readmemh(`INST_FILE_PATH_BPTEST, data);
    end
    
    assign output_inst = data[addr / 4];        //addr 

endmodule
