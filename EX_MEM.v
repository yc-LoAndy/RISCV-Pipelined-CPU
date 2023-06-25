module EX_MEM(
	clk_i,
	rst_i,
	RegWrite_i, RegWrite_o,
	MemtoReg_i, MemtoReg_o,
	MemRead_i, MemRead_o,
	MemWrite_i, MemWrite_o,
	ALUout_i, ALUout_o,
	DM_writedata_i, DM_writedata_o,
	rd_i, rd_o,
);

input	clk_i;
input	rst_i;
input 	RegWrite_i; output reg RegWrite_o;
input 	MemtoReg_i; output reg MemtoReg_o;
input 	MemRead_i;  output reg MemRead_o;
input 	MemWrite_i; output reg MemWrite_o;
input [31:0]		ALUout_i;
output reg [31:0] 	ALUout_o;
input [31:0]		DM_writedata_i;
output reg [31:0]	DM_writedata_o;
input [4:0]			rd_i;
output reg [4:0]	rd_o;

always @(posedge clk_i or negedge rst_i) begin
	if (~rst_i) begin
		RegWrite_o <= 0; MemtoReg_o <= 0;
		MemRead_o <= 0;  MemWrite_o <= 0;
		ALUout_o <= 0;
		DM_writedata_o <= 0;
		rd_o <= 0;
	end
	else begin
		RegWrite_o <= RegWrite_i; MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;  MemWrite_o <= MemWrite_i;
		ALUout_o <= ALUout_i;
		DM_writedata_o <= DM_writedata_i;
		rd_o <= rd_i;
	end
end

endmodule
