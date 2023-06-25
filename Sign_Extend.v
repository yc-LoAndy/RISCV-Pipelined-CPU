module Sign_Extend
(
	instruction,
	imme_o
);

input [31:0]		instruction;
output reg [31:0]	imme_o;
wire [6:0]			opcode;
wire [2:0]			funct3;

assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];

always @(*) begin
	if (opcode == 7'b0010011) begin	// addi & srai
		if (funct3 == 3'b000)
			imme_o <= {{20{instruction[31]}}, instruction[31:20]};
		else if (funct3 == 3'b101)
			imme_o <= {{27{instruction[24]}}, instruction[24:20]};
	end
	else if (opcode == 7'b0000011)
		imme_o <= {{20{instruction[31]}}, instruction[31:20]};
	else if (opcode == 7'b0100011)
		imme_o <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
	else if (opcode == 7'b1100011)
		imme_o <= {{21{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8]};
end

endmodule
