module MEM_WB(
	clk_i,
	rst_i,
	RegWrite_i, RegWrite_o,
	MemtoReg_i, MemtoReg_o,
	ALUout_i, ALUout_o,
	DMdata_i, DMdata_o,
	rd_i, rd_o,
);

input	clk_i;
input	rst_i;
input 	RegWrite_i; output reg RegWrite_o;
input 	MemtoReg_i; output reg MemtoReg_o;
input [31:0]		ALUout_i;
output reg [31:0] 	ALUout_o;
input [31:0]		DMdata_i;
output reg [31:0]	DMdata_o;
input [4:0]			rd_i;
output reg [4:0]	rd_o;

always @(posedge clk_i or negedge rst_i) begin
	if (~rst_i) begin
		MemtoReg_o <= 0;
		ALUout_o <= 0;
		DMdata_o <= 0;
		rd_o <= 0;
		RegWrite_o <= 0;
	end
	else begin
		MemtoReg_o <= MemtoReg_i;
		ALUout_o <= ALUout_i;
		DMdata_o <= DMdata_i;
		rd_o <= rd_i;
		RegWrite_o <= RegWrite_i;
	end
end

endmodule
