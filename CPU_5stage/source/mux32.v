module mux32(
    input   [31: 0] input_data1,
    input   [31: 0] input_data2,
    input           sel,
    
    output  [31: 0] output_data
);
    
    assign output_data = (sel == 1)? input_data1 : input_data2;

endmodule
