`define TRACE_FILE_PATH "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\cpu_trace"
`define INST_FILE_PATH "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\inst_data.txt"
`define DATA_FILE_PATH "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\data_data.txt"
`define GPRS_FILE_PATH "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\reg_data.txt"
`define INST_FILE_PATH_TEST1 "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\inst_data_test1.txt"
`define INST_FILE_PATH_BPTEST "E:\\HITCPU\\Computer_Arch_Lab1\\CPU_Pipe\\CPU_Pipe.data\\inst_data_bptest.txt"

`define ADD 6'b100000   //funcode
`define SUB 6'b100010
`define AND 6'b100100
`define OR 6'b100101
`define XOR 6'b100110
`define SLT 6'b101010
`define MOVZ 6'b001010
`define SLL 6'b000000
`define ALU 6'b000000   //opcode
`define SW 6'b101011
`define LW 6'b100011
`define BNE 6'b000101
`define J 6'b000010