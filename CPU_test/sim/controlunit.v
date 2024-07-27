`include "./cpu.vh"

module controlunit(
    input   [5: 0]      opcode,
    input   [10: 0]     alu_funcode,
    input               clk, rst_n, equal,
    input   [31: 0]     rt_data,
    
    output  reg     pc_en,
    output  reg     pc_sel,
    output  reg     npc_en,
    output  reg     ir_en,
    output  reg     reg_wen,
    output  reg     mem_wen,
    output  reg     wb_sel_wen,
    output  reg     mux1_sel,
    output  reg     mux2_sel,
    output  reg     dmem_sel,
    output  reg     [10: 0] alu_op,
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
    parameter [9: 0] state_wbreg = 10'b1000000000;
    
    always@ (posedge clk) begin
        if(!rst_n) begin            //low reset
            pc_en       <= 0;
            pc_sel      <= 0;
            npc_en      <= 1;
            ir_en       <= 0;
            reg_wen     <= 0;
            mem_wen     <= 0;
            wb_sel_wen  <= 0;
            mux1_sel    <= 0;
            mux2_sel    <= 0;
            dmem_sel    <= 0;
            state       <= state_wb;      //default state is writeback
            next_state  <= state_if;      //clk rise turn state into fetch
        end
        else begin
            state   <=  next_state;
            case(opcode)        //according to the opcode decide function
                ALU  : alu_op <= alu_funcode[10: 0];
                `SW  : alu_op <= `SW;
                `LW  : alu_op <= `LW;
                `BNE : alu_op <= `BNE;
                `J   : alu_op <= `J;
                default: alu_op <= `J;
            endcase
            
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
            pc_en       <= (state == state_wb)? 1'b1 : 1'b0;    //pc_reg
            ir_en       <= (state == state_if)? 1'b1 : 1'b0;
            mem_wen     <= (state == state_exreg && opcode == `SW)? 1'b1 : 1'b0;
            pc_sel      <= (state == state_wb && (opcode == `J || (opcode == `BNE && equal == 1)))? 1'b1 : 1'b0;
            wb_sel_wen  <= (opcode == `LW)? 1'b1 : 1'b0;
            mux1_sel    <= (opcode == `J || opcode == `BNE)? 1'b0 : 1'b1;       //jmp imm or rs_data
            mux2_sel    <= (opcode == `J || opcode == `BNE || opcode == `LW || opcode == `SW)? 1'b0 : 1'b1;
            dmem_sel    <= (opcode == `LW)? 1'b0 : 1'b1;
            if(state == state_ma && (opcode == `LW || (opcode == ALU && !(alu_op[5: 0] == `MOVZ && rt_data != 0)))) begin
                reg_wen <= 1'b1;
            end
            else begin
                reg_wen <= 1'b0;
            end
        end
    end

endmodule