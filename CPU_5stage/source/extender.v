`include "./cpu.vh"

module extender(
    input   [5: 0]  opcode,
    input   [25: 0] input_26bit,        //jmp inst_index
    
    output  [31: 0] output_32bit
);

    assign output_32bit[31: 0] = (opcode == `J)? { {6{input_26bit[25]}}, input_26bit[25: 0] } : { {16{input_26bit[15]}}, input_26bit[15: 0]};

endmodule
