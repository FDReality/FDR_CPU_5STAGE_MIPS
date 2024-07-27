`include "./cpu.vh"

module controlunit(
    input               clk, rst_n,
    
    output  reg     id_ex_wen,
    output  reg     exe_wen,
    output  reg     mem_en,
    output  [9: 0]  pipe_state
);

    parameter [5: 0] ALU = 6'b000000;       //alu opcode

    reg [9: 0]  state;
    reg [9: 0]  next_state;
    
    assign pipe_state = state;
    
    parameter [9: 0] state_if    = 10'b0000000001;
    parameter [9: 0] state_id    = 10'b0000000010;
    parameter [9: 0] state_ex    = 10'b0000000100;
    parameter [9: 0] state_ma    = 10'b0000001000;
    parameter [9: 0] state_wb    = 10'b0000010000;
    parameter [9: 0] state_ifreg = 10'b0000100000;
    parameter [9: 0] state_idreg = 10'b0001000000;
    parameter [9: 0] state_exreg = 10'b0010000000;
    parameter [9: 0] state_mareg = 10'b0100000000;
    
    always@ (posedge clk) begin
        if(!rst_n) begin            //low reset
            id_ex_wen   <= 0;
            exe_wen     <= 0;
            mem_en      <= 0;
            state       <= state_wb;      //default state is writeback
            next_state  <= state_if;      //clk rise turn state into fetch
        end
        else begin
            state   <=  next_state;
            
            case(next_state)
                state_if    : next_state <= state_ifreg;
                state_ifreg : next_state <= state_id;
                state_id    : next_state <= state_idreg;
                state_idreg : next_state <= state_ex;
                state_ex    : next_state <= state_exreg;
                state_exreg : next_state <= state_ma;
                state_ma    : next_state <= state_mareg;
                state_mareg : next_state <= state_wb;
                state_wb    : next_state <= state_if;
            endcase
            //according to the opcode and funcode decide control signal
            id_ex_wen   <= 1'b1;
            exe_wen     <= 1'b1;
            mem_en      <= 1'b1;
        end
    end

endmodule