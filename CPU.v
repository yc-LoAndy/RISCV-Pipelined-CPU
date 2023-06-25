module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input			clk_i;
input			rst_i;


// PC
wire [31:0]		pc;
wire [31:0]		pcplus4;
wire [31:0]		pcnxt;
wire 			PCWrite;
wire [1:0]		PCSrc;
wire [31:0]		SignExtended;
wire [31:0]		SignExtendeds1;
wire [31:0]		branch_target;
wire [31:0]		rollback_addr;

Adder Add_PC(
	.in(pc),
	.amt(32'h00000004),
	.out(pcplus4)
);

MUX_4way MUX_PC(
	.opt0(pcplus4),
	.opt1(branch_target),
	.opt2(rollback_addr),
	.sel_i(PCSrc),
	.result_o(pcnxt)
);

PC	PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.PCWrite_i(PCWrite),
	.pc_i(pcnxt),
	.pc_o(pc)
);


// Instruction
wire [31:0]		Instruction;

Instruction_Memory Instruction_Memory(
	.addr_i(pc),
	.instr_o(Instruction)
);


// IF_ID Pipeline register
wire			Noop;
wire 			Stall;
wire [31:0]		ID_pc;
wire [31:0]		ID_pcplus4;
wire [31:0]		ID_Instruction;
wire			ID_flush_1;
wire			ID_flush_2;

IF_ID IF_ID(
	.rst_i(rst_i),
	.clk_i(clk_i),
    .pc_i(pc),
	.pcplus4_i(pcplus4),
	.instruction_i(Instruction),
	.stall_i(Stall),
	.flush1_i(ID_flush_1),
	.flush2_i(ID_flush_2),
	.pc_o(ID_pc),
	.pcplus4_o(ID_pcplus4),
	.instruction_o(ID_Instruction)
);

// Branch target adding unit
assign SignExtendeds1 = SignExtended << 1;
Adder Add_branch(
	.in(ID_pc),
	.amt(SignExtendeds1),
	.out(branch_target)
);

// Hazard Detection Unit
Hazard_Detection_Unit Hazard_Detection_Unit(
	.rst_i(rst_i),
	.ID_rs1_i(ID_Instruction[19:15]),
	.ID_rs2_i(ID_Instruction[24:20]),
	.EX_MemRead_i(EX_MemRead),
	.EX_rd_i(EX_rd),
	.Noop_o(Noop),
	.Stall_o(Stall),
	.PCWrite_o(PCWrite)
);

// Control Unit
wire [1:0]		ALUOp;
wire 			ALUSrc;
wire			RegWrite;
wire 			MemtoReg;
wire 			MemRead;
wire 			MemWrite;
wire			Branch;

Control Control(
	.rst_i(rst_i),
	.opcode_i(ID_Instruction[6:0]),
	.Noop_i(Noop),
	.ALUOp(ALUOp),
	.ALUSrc(ALUSrc),
	.RegWrite(RegWrite),
	.MemtoReg(MemtoReg),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.Branch(Branch)
);


// Register
wire			WB_RegWrite;
wire [31:0]		RegData1;
wire [31:0]		RegData2;
wire [31:0] 	WB_RegWriteData;
wire [4:0]		WB_rd;

Registers Registers(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RS1addr_i(ID_Instruction[19:15]),
    .RS2addr_i(ID_Instruction[24:20]),
    .RDaddr_i(WB_rd),
    .RDdata_i(WB_RegWriteData),
    .RegWrite_i(WB_RegWrite), 
    .RS1data_o(RegData1), 
    .RS2data_o(RegData2) 
);


// Sign extender
Sign_Extend Sign_Extend(
	.instruction(ID_Instruction),
	.imme_o(SignExtended)
);

// Branch Predictor
wire			Zero;
wire [1:0]		update;
wire [1:0]		state;
wire 			RollBack;
Branch_predictor Branch_predictor(
	.clk_i(clk_i),
    .rst_i(rs1_i),
	.update_i(update),
	.ID_Branch_i(Branch),
	.EX_Branch_i(EX_Branch),
	.rbk_i(RollBack),
	.state_o(state),
	.PCSrc_o(PCSrc),
	.ID_flush_o(ID_flush_1)
);


// ID_EX Pipeline Register
wire			EX_flush;
wire			EX_RegWrite;
wire			EX_MemtoReg;
wire			EX_MemRead;
wire			EX_MemWrite;
wire [1:0]		EX_ALUOp;
wire			EX_ALUSrc;
wire			EX_Branch;
wire [31:0]		EX_RegData1;
wire [31:0]		EX_RegData2;
wire [31:0]		EX_SignExtended;
wire [2:0]		EX_funct3;
wire [6:0]		EX_funct7;
wire [4:0]		EX_rs1;
wire [4:0]		EX_rs2;
wire [4:0]		EX_rd;
wire [6:0]		EX_opcode;
wire [31:0]		EX_pcplus4;
wire [31:0]		EX_branch_target;
wire [1:0]		EX_PCSrc;
wire [1:0]		EX_state;

ID_EX ID_EX(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.flush_i(EX_flush),
	.RegWrite_i(RegWrite), .RegWrite_o(EX_RegWrite),
	.MemtoReg_i(MemtoReg), .MemtoReg_o(EX_MemtoReg),
	.MemRead_i(MemRead), .MemRead_o(EX_MemRead),
	.MemWrite_i(MemWrite), .MemWrite_o(EX_MemWrite),
	.ALUOp_i(ALUOp), .ALUOp_o(EX_ALUOp),
	.ALUSrc_i(ALUSrc), .ALUSrc_o(EX_ALUSrc),
	.Branch_i(Branch), .Branch_o(EX_Branch),
	.reg1_i(RegData1), .reg1_o(EX_RegData1),
	.reg2_i(RegData2), .reg2_o(EX_RegData2),
	.imme_i(SignExtended), .imme_o(EX_SignExtended),
	.funct3_i(ID_Instruction[14:12]), .funct3_o(EX_funct3),
	.funct7_i(ID_Instruction[31:25]), .funct7_o(EX_funct7),
	.rs1_i(ID_Instruction[19:15]), .rs1_o(EX_rs1),
	.rs2_i(ID_Instruction[24:20]), .rs2_o(EX_rs2),
	.rd_i(ID_Instruction[11:7]), .rd_o(EX_rd),
	.opcode_i(ID_Instruction[6:0]), .opcode_o(EX_opcode),
	.pcplus4_i(ID_pcplus4), .pcplus4_o(EX_pcplus4),
	.branch_target_i(branch_target), .branch_target_o(EX_branch_target),
	.PCSrc_i(PCSrc), .PCSrc_o(EX_PCSrc),
	.state_i(state), .state_o(EX_state)
);


// Multiplexers for ALU operands source
wire			MEM_RegWrite;
wire [31:0]		MEM_ALUOut;
wire [1:0]		ForwardA;
wire [1:0]		ForwardB;
wire [31:0]		operand_1;
wire [31:0]		operand_2;
wire [31:0]		BOut;

Forwarding_Unit Forwarding_Unit(
	.rst_i(rs1_i),
	.MEM_RegWrite_i(MEM_RegWrite),
	.MEM_Rd_i(MEM_rd),
	.WB_RegWrite_i(WB_RegWrite),
	.WB_Rd_i(WB_rd),
	.EX_Rs1_i(EX_rs1),
	.EX_Rs2_i(EX_rs2),
	.ForwardA_o(ForwardA),
	.ForwardB_o(ForwardB)
);

MUX_4way MUX4_1(
	.opt0(EX_RegData1),
	.opt1(WB_RegWriteData),
	.opt2(MEM_ALUOut),
	.sel_i(ForwardA),
	.result_o(operand_1)
);

MUX_4way MUX4_2(
	.opt0(EX_RegData2),
	.opt1(WB_RegWriteData),
	.opt2(MEM_ALUOut),
	.sel_i(ForwardB),
	.result_o(BOut)
);

MUX_2way MUX_ALUSrc(
	.opt0(BOut),
	.opt1(EX_SignExtended),
	.sel_i(EX_ALUSrc),
	.result_o(operand_2)
);


// ALU Control
wire [2:0] 		ALUCtrlOut;

ALU_Control ALU_Control(
	.opcode(EX_opcode),
	.funct3(EX_funct3),
	.funct7(EX_funct7),
	.ALUOp(EX_ALUOp),
	.control_o(ALUCtrlOut)
);


// ALU
wire [31:0]		ALUOut;
ALU ALU(
	.opsrc1_i(operand_1),
	.opsrc2_i(operand_2),
	.control_i(ALUCtrlOut),
	.result_o(ALUOut),
	.Zero_o(Zero)
);


// Multiplexer for rollback address
MUX_2way MUX_rbk(
	.opt0(EX_branch_target),
	.opt1(EX_pcplus4),
	.sel_i(EX_PCSrc[0]),
	.result_o(rollback_addr)
);


// Branch Flush 2 Checking
Branch_update Branch_update(
	.Zero_i(Zero),
	.EX_Branch_i(EX_Branch),
	.state_i(EX_state),
	.rbk_o(RollBack),
	.ID_flush_o(ID_flush_2),
	.EX_flush_o(EX_flush),
	.update_o(update)
);


// EX_MEM Pipeline Register
wire			MEM_MemtoReg;
wire			MEM_MemRead;
wire			MEM_MemWrite;
wire [31:0]		MEM_MemWriteData;
wire [4:0]		MEM_rd;


EX_MEM EX_MEM(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RegWrite_i(EX_RegWrite), .RegWrite_o(MEM_RegWrite),
	.MemtoReg_i(EX_MemtoReg), .MemtoReg_o(MEM_MemtoReg),
	.MemRead_i(EX_MemRead), .MemRead_o(MEM_MemRead),
	.MemWrite_i(EX_MemWrite), .MemWrite_o(MEM_MemWrite),
	.ALUout_i(ALUOut), .ALUout_o(MEM_ALUOut),
	.DM_writedata_i(BOut), .DM_writedata_o(MEM_MemWriteData),
	.rd_i(EX_rd), .rd_o(MEM_rd)
);


// Data Memory
wire [31:0] 	MemReadData;

Data_Memory Data_Memory(
	.clk_i(clk_i), 
    .addr_i(MEM_ALUOut), 
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_i(MEM_MemWriteData),
    .data_o(MemReadData)
);


// MEM_WB Pipeline Register
wire			WB_MemtoReg;
wire [31:0]		WB_ALUOut;
wire [31:0]		WB_MemReadData;

MEM_WB MEM_WB(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.RegWrite_i(MEM_RegWrite), .RegWrite_o(WB_RegWrite),
	.MemtoReg_i(MEM_MemtoReg), .MemtoReg_o(WB_MemtoReg),
	.ALUout_i(MEM_ALUOut), .ALUout_o(WB_ALUOut),
	.DMdata_i(MemReadData), .DMdata_o(WB_MemReadData),
	.rd_i(MEM_rd), .rd_o(WB_rd)
);


// Multiplexer for data to write into the register
MUX_2way MUX_RegWriteData(
	.opt0(WB_ALUOut),
	.opt1(WB_MemReadData),
	.sel_i(WB_MemtoReg),
	.result_o(WB_RegWriteData)
);

endmodule
