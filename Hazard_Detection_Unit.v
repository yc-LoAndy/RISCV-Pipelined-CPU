module Hazard_Detection_Unit(
	rst_i,
	ID_rs1_i,
	ID_rs2_i,
	EX_MemRead_i,
	EX_rd_i,
	Noop_o,
	Stall_o,
	PCWrite_o
);

input			rst_i;
input [4:0]		ID_rs1_i;
input [4:0]		ID_rs2_i;
input			EX_MemRead_i;
input [4:0]		EX_rd_i;
output reg		Noop_o;
output reg		Stall_o;
output reg		PCWrite_o;

always @(*) begin
	if (~rst_i) begin
		Noop_o <= 0;
		Stall_o <= 0;
		PCWrite_o <= 1;
	end
	else begin
		Noop_o <= 0;
		Stall_o <= 0;
		PCWrite_o <= 1;
		if ((EX_MemRead_i) && ((EX_rd_i == ID_rs1_i) || (EX_rd_i == ID_rs2_i))) begin
			Noop_o <= 1;
			Stall_o <= 1;
			PCWrite_o <= 0;
		end
	end
end

endmodule
