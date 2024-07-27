`include "./cpu.vh"

module dmem(        //enter addr fetch inst
    input [31: 0]   alu_addr,
    input [31: 0]   data,
    input           we, clk, rst_n,
    
    output[31: 0]   output_data
);

    reg [31: 0] data_mem[255: 0];      //256¡Á32 inst mem
    
    initial begin
        $readmemh(`DATA_FILE_PATH, data_mem);
    end
    
    assign output_data = data_mem[alu_addr / 4];
    
    always@ (posedge clk) begin
        if(!rst_n)
            data_mem[alu_addr / 4] = 32'h00000000;
        else begin
            if(we == 1) begin
                data_mem[alu_addr / 4] <= data;
            end
        end
    end
    
endmodule