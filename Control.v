module Control
(
	rst_i,
	opcode_i,
	Noop_i,
	ALUOp,
	ALUSrc,
	RegWrite,
	MemtoReg,
	MemRead,
	MemWrite,
	Branch
);

input				rst_i;
input [6:0] 		opcode_i;
input				Noop_i;
output reg [1:0]	ALUOp;
output reg			ALUSrc;
output reg			RegWrite;
output reg			MemtoReg;
output reg			MemRead;
output reg			MemWrite;
output reg			Branch;

always @(*) begin
	if (~rst_i || Noop_i == 1 || opcode_i == 0) begin
		ALUSrc <= 0;
		RegWrite <= 0;
		ALUOp <= 0;
		MemtoReg <= 0;
		MemRead <= 0;
		MemWrite <= 0;
		Branch <= 0;
	end
	else begin
		if (opcode_i == 7'b0110011 || opcode_i == 7'b1100011)
			ALUSrc <= 0;
		else
			ALUSrc <= 1;
		
		if (opcode_i == 7'b0100011 || opcode_i == 7'b1100011)
			RegWrite <= 0;
		else
			RegWrite <= 1;
		
		if (opcode_i == 7'b0110011 || opcode_i == 7'b0010011)
			ALUOp <= 2'b10;
		else if (opcode_i == 7'b1100011)
			ALUOp <= 2'b01;
		else
			ALUOp <= 2'b00;
		
		if (opcode_i == 7'b0000011) begin
			MemtoReg <= 1;
			MemRead <= 1;
		end
		else begin
			MemtoReg <= 0;
			MemRead <= 0;
		end
		
		if (opcode_i == 7'b0100011)
			MemWrite <= 1;
		else
			MemWrite <= 0;
		
		if (opcode_i == 7'b1100011)
			Branch <= 1;
		else
			Branch <= 0;

	end
end


endmodule
