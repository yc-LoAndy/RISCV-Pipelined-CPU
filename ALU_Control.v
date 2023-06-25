module ALU_Control
(
	opcode,
	funct7,
	funct3,
	ALUOp,
	control_o
);

input [6:0]			opcode;
input [6:0]			funct7;
input [2:0]			funct3;
input [1:0]			ALUOp;
output reg [2:0]	control_o;

always @(*) begin
	if (ALUOp == 2'b00)
		control_o <= 3'b011;
	else if (ALUOp == 2'b01)
		control_o <= 3'b110;							// beq: 6
	else if (ALUOp == 2'b10) begin
		if (opcode == 7'b0110011) begin			// R-type instruction
			if (funct7 == 0) begin
				case (funct3)
					3'b111: control_o <= 3'b000;		// and: 0
					3'b100: control_o <= 3'b001;		// xor: 1
					3'b001: control_o <= 3'b010;		// sll: 2
					3'b000: control_o <= 3'b011;		// add: 3
				endcase
			end
			else if (funct7 == 7'b0100000)
				control_o <= 3'b100;					// sub: 4
			else if (funct7 == 7'b0000001)
				control_o <= 3'b101;					// mul: 5
		end
		else if (opcode == 7'b0010011) begin	// Immediate instruction
			if (funct3 == 3'b000)
				control_o <= 3'b011;					// addi: 3
			else if (funct3 == 3'b101)
				control_o <= 3'b111;					// srai: 7
		end
	end
end

endmodule
