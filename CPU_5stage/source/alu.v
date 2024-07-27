`include "./cpu.vh"

module alu(
    input   [5: 0]  alu_op,
    input   [31: 0] input_data1,    //rs_data
    input   [31: 0] input_data2,    //rt_data
    input           rst_n,
    
    output  [31: 0] output_result,
    output          equal_mov
);

    reg [31: 0] result;
    reg         equal;
    reg [31: 0] temp;
    
    assign output_result = result;
    assign equal_mov = equal;
    
    always@ (*) begin
        if(!rst_n) begin
            result = 32'b0;
            temp = 32'b0;
        end
        else begin
            case(alu_op[5: 0])
                `ADD :  result = input_data1 + input_data2;
                `SUB :  result = input_data1 - input_data2;
                `AND :  result = input_data1 & input_data2;
                `OR  :  result = input_data1 | input_data2;
                `XOR :  result = input_data1 ^ input_data2;
                `SLT :  result = (input_data1 < input_data2) ? 32'h00000001 : 32'h00000000;
                `MOVZ:  result = (input_data2 == 0) ? input_data1 : 32'h00000000;
                `SLL :  result = input_data1 << input_data2;    //SLL s1, s2, 4(inst[10: 6])  :  s1 = (s2) << 4 
                `BNE :  begin
                            result = (input_data2 << 2) + input_data1;
                            equal = (input_data1 - input_data2)? 1 : 0;
                        end
                `J   :  begin
                            temp = input_data2 << 2;
                            result = {input_data1[31: 26], temp[25: 0]};
                        end
                default : begin     //LW rt, offset(base) -->  [rt] <- Mem[[base] + offset]
                                result = input_data1 + input_data2;
                          end
            endcase
        end
    end

endmodule
