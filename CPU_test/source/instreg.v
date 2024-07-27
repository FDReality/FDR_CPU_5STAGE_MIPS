module instreg(
    input   [31: 0]     input_inst,
    input               ir_en,
    input               clk,
    input               rst_n,
    
    output reg  [31: 0] output_inst
);

    always@ (posedge clk) begin
        if(!rst_n)
            output_inst <= 32'h00000000;
        else
            output_inst <= (ir_en == 1)? input_inst : output_inst;
    end
    
endmodule