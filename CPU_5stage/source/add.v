module add(
    input   [31: 0] index1, index2,
    
    output  [31: 0] result
);

    assign  result = index1 + index2;

endmodule