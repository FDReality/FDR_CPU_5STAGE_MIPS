module equal(
    input   [31: 0] data1,
    input   [31: 0] data2,
    input           clk,
    input           rst_n,
    
    output  reg     equal
);

    always@ (posedge clk) begin
        if(!rst_n)
            equal = 1'b0;
        else
            equal = (data1 == data2);
    end

endmodule
