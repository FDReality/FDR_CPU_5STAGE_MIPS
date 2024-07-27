`include "./cpu.vh"

module registers(
    input   [4: 0]  rs1, rs2, wb_addr,
    input   [31: 0] wb_data,
    input           clk, rst_n, we,
    
    output  [31: 0] output_data_1, output_data_2
);

    reg [31: 0] datareg[31: 0];
    
    assign output_data_1 = datareg[rs1];
    assign output_data_2 = datareg[rs2];
    
    initial begin
        $readmemb(`GPRS_FILE_PATH, datareg);
    end
    
    always@ (posedge clk) begin
        if(!rst_n) begin
            // output_data_1 = 32'h00000000;
        end
        else begin
            if(we == 1)
                datareg[wb_addr] <= wb_data;
        end
    end
    
endmodule