module alu_output(
    input   [31: 0]     input_data,
    input               clk,
    input               rst_n,
    
    output  reg [31: 0] output_data
);

    always@ (posedge clk)   begin
        if(!rst_n)
            output_data = 32'h00000000;
        else
            output_data = input_data;
    end

endmodule