# RISCV-Pipelined-CPU
A simple CPU supporting multiple basic instructions, with a 2-bit dynamic branch predictor. Implemented with Verilog.\
Lab work in Computer Architecture 2023 Spring, NTU.

## Pipeline Design
![image](https://github.com/yc-LoAndy/RISCV-Pipelined-CPU/blob/b5621f80270598969de845c6088ac65fc33bc5fc/pic/CA111-2_lab2_spec-cropped-5-1.png)\
Note that the branch predictor system is not shown on the graph. A branch predictor module, giving prediction upon branch instruction, is located at the ID stage, and a branch update module, updating the state of the branch predictor, is located at the EX stage. An adder in the EX stage is used to compute the rollback address for misprediction, and another multiplexer in the front of the PC selects the correct address of the next instruction among PC+4, target address, and rollback address.

## Supported Instructions and Format
| funct7 | rs2 | rs1 | funct3 | rd | opcode | function |
| ------ | --- | --- | ------ | -- | ------ | -------- |
| 0000000 | rs2 | rs1 | 111 | rd | 0110011 | and |
| 0000000 | rs2 | rs1 | 100 | rd | 0110011 | xor |
| 0000000 | rs2 | rs1 | 001 | rd | 0110011 | sll |
| 0000000 | rs2 | rs1 | 000 | rd | 0110011 | add |
| 0100000 | rs2 | rs1 | 000 | rd | 0110011 | sub |
| 0000001 | rs2 | rs1 | 000 | rd | 0110011 | mul |
| imm[11\:0] || rs1 | 000 | rd | 0010011 | addi |
| 0100000 | imm[4\:0] | rs1 | 101 | rd | 0010011 | srai |
| imm[11\:0] || rs1 | 010 | rd | 0000011 | lw |
| imm[11\:5] | rs2 | rs1 | 010 | imm[4\:0] | 0100011 | sw |
| imm[12, 10\:5] | rs2 | rs1 | 000 | imm[4\:1, 11] | 1100011 | beq |
