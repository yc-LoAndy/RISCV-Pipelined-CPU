module ALU
(
	opsrc1_i,
	opsrc2_i,
	control_i,
	result_o,
	Zero_o
);

input [31:0]			opsrc1_i;
input [31:0]			opsrc2_i;
input [2:0]				control_i;
output reg [31:0]		result_o;
output					Zero_o;

always @(*) begin
	case (control_i)
		3'b000:			// and
			result_o <= opsrc1_i & opsrc2_i;

		3'b001:			// xor
			result_o <= opsrc1_i ^ opsrc2_i;

		3'b010:			// sll
			result_o <= opsrc1_i << opsrc2_i;

		3'b011:			// add
			result_o <= opsrc1_i + opsrc2_i;

		3'b100:			// sub
			result_o <= opsrc1_i - opsrc2_i;

		3'b101:			// mul
			result_o <= opsrc1_i * opsrc2_i;
		
		3'b110:			// beq
			result_o <= opsrc1_i - opsrc2_i;

		3'b111:			// srai
			result_o <= opsrc1_i >>> opsrc2_i;
		default: result_o <= 32'b0;
	endcase
end

assign Zero_o = (opsrc1_i == opsrc2_i) ? (1) : (0);

endmodule
