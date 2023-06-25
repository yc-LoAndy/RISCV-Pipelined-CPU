module ID_EX(
	clk_i,
	rst_i,
	flush_i,
	RegWrite_i, RegWrite_o,
	MemtoReg_i, MemtoReg_o,
	MemRead_i, MemRead_o,
	MemWrite_i, MemWrite_o,
	ALUOp_i, ALUOp_o,
	ALUSrc_i, ALUSrc_o,
	Branch_i, Branch_o,
	reg1_i, reg1_o,
	reg2_i, reg2_o,
	imme_i, imme_o,
	funct3_i, funct3_o,
	funct7_i, funct7_o,
	rs1_i, rs1_o,
	rs2_i, rs2_o,
	rd_i, rd_o,
	opcode_i, opcode_o,
	pcplus4_i, pcplus4_o,
	branch_target_i, branch_target_o,
	PCSrc_i, PCSrc_o,
	state_i, state_o
);

input	clk_i;
input	rst_i;
input	flush_i;
input 	RegWrite_i; output reg RegWrite_o;
input 	MemtoReg_i; output reg MemtoReg_o;
input 	MemRead_i;  output reg MemRead_o;
input 	MemWrite_i; output reg MemWrite_o;
input [1:0] ALUOp_i;output reg [1:0] ALUOp_o;
input 	ALUSrc_i;	output reg ALUSrc_o;
input 	Branch_i; 	output reg Branch_o;
input [31:0]			reg1_i;
input [31:0]			reg2_i;
output reg [31:0]		reg1_o;
output reg [31:0]		reg2_o;
input [31:0]			imme_i;
output reg [31:0]		imme_o;
input [2:0]				funct3_i;
output reg [2:0]		funct3_o;
input [6:0]				funct7_i;
output reg [6:0]		funct7_o;
input [4:0]				rs1_i;
output reg [4:0]		rs1_o;
input [4:0]				rs2_i;
output reg [4:0]		rs2_o;
input [4:0]				rd_i;
output reg [4:0]		rd_o;
input [6:0]				opcode_i;
output reg [6:0]		opcode_o;
input [31:0]			pcplus4_i;
output reg [31:0]		pcplus4_o;
input [31:0]			branch_target_i;
output reg [31:0]		branch_target_o;
input [1:0]				PCSrc_i;
output reg [1:0]		PCSrc_o;
input [1:0]				state_i;
output reg [1:0]		state_o;

always @(posedge clk_i or negedge rst_i) begin
	if (~rst_i || flush_i) begin
		RegWrite_o <= 0; MemtoReg_o <= 0;
		MemRead_o <= 0;  MemWrite_o <= 0;
		ALUOp_o <= 0;	 ALUSrc_o <= 0;
		Branch_o <= 0;
		reg1_o <= 0; 	 reg2_o <= 0;
		imme_o <= 0;
		funct3_o <= 0; 	 funct7_o <= 0;
		rs1_o <= 0; rs2_o <= 0; rd_o <= 0;
		opcode_o <= 0;
		pcplus4_o <= 0; branch_target_o <= 0;
		PCSrc_o <= 0;
		state_o <= state_i;
	end
	else begin
		RegWrite_o <= RegWrite_i; MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;   MemWrite_o <= MemWrite_i;
		ALUOp_o <= ALUOp_i;		  ALUSrc_o <= ALUSrc_i;
		Branch_o <= Branch_i;
		reg1_o <= reg1_i;		  reg2_o <= reg2_i;
		imme_o <= imme_i;
		funct3_o <= funct3_i; 	  funct7_o <= funct7_i;
		rs1_o <= rs1_i; rs2_o <= rs2_i; rd_o <= rd_i;
		opcode_o <= opcode_i;
		pcplus4_o <= pcplus4_i;
		branch_target_o <= branch_target_i;
		PCSrc_o <= PCSrc_i;
		state_o <= state_i;
	end
end

endmodule
