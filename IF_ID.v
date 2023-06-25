module IF_ID(
	rst_i,
	clk_i,
    pc_i,
	pcplus4_i,
	instruction_i,
	stall_i,
	flush1_i,
	flush2_i,
	pc_o,
	pcplus4_o,
	instruction_o
);

input				rst_i;
input				clk_i;
input [31:0]		pc_i;
input [31:0]		pcplus4_i;
input [31:0]		instruction_i;
input				stall_i;
input				flush1_i;
input				flush2_i;
output reg [31:0]	pc_o;
output reg [31:0]	pcplus4_o;
output reg [31:0]	instruction_o;

always @(posedge clk_i or negedge rst_i) begin
	if (~rst_i || flush1_i || flush2_i) begin
		pc_o <= 0; pcplus4_o <= 0;
		instruction_o <= 0;
	end
	else if (~stall_i) begin
		pc_o <= pc_i;
		pcplus4_o <= pcplus4_i;
		instruction_o <= instruction_i;
	end
end

endmodule
