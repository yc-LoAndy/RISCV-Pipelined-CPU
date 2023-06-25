module Forwarding_Unit(
	rst_i,
	MEM_RegWrite_i,
	MEM_Rd_i,
	WB_RegWrite_i,
	WB_Rd_i,
	EX_Rs1_i,
	EX_Rs2_i,
	ForwardA_o,
	ForwardB_o
);

input				rst_i;
input				MEM_RegWrite_i;
input [4:0]			MEM_Rd_i;
input				WB_RegWrite_i;
input [4:0]			WB_Rd_i;
input [4:0]			EX_Rs1_i;
input [4:0]			EX_Rs2_i;
output reg [1:0]	ForwardA_o;
output reg [1:0]	ForwardB_o;

always @(*) begin
	if (~rst_i) begin
		ForwardA_o <= 0;
		ForwardB_o <= 0;
	end
	else begin
		ForwardA_o <= 0;
		ForwardB_o <= 0;

		// EX Hazard
		if ((MEM_RegWrite_i) && (MEM_Rd_i != 0) && (MEM_Rd_i == EX_Rs1_i))
			ForwardA_o <= 2'b10;

		if ((MEM_RegWrite_i) && (MEM_Rd_i != 0) && (MEM_Rd_i == EX_Rs2_i))
			ForwardB_o <= 2'b10;

		// MEM Hazard
		if ((WB_RegWrite_i) && (WB_Rd_i != 0) && !((MEM_RegWrite_i) && (MEM_Rd_i != 0) && (MEM_Rd_i == EX_Rs1_i)) && (WB_Rd_i == EX_Rs1_i))
			ForwardA_o <= 2'b01;

		if ((WB_RegWrite_i) && (WB_Rd_i != 0) && !((MEM_RegWrite_i) && (MEM_Rd_i != 0) && (MEM_Rd_i == EX_Rs2_i)) && (WB_Rd_i == EX_Rs2_i))
			ForwardB_o <= 2'b01;
	end
end

endmodule
