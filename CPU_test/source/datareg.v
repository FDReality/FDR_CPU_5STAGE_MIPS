module datareg(
    input   [31: 0] input_data,
    input           clk,
    
    output  [31: 0] output_data
);
    reg [31: 0] result;
    
    assign output_data = result;
    
    always@ (posedge clk) begin
        result <= input_data;
    end

endmodule
