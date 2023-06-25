module Branch_predictor
(
    clk_i, 
    rst_i,
	update_i,
	ID_Branch_i,
	EX_Branch_i,
	rbk_i,
	state_o,
	PCSrc_o,
	ID_flush_o
);
input 				clk_i, rst_i;
input [1:0] 		update_i;
input 				ID_Branch_i, EX_Branch_i;
input				rbk_i;
output reg [1:0] 	state_o;
output reg [1:0] 	PCSrc_o;	// 00: PC+4, 01: target address, 10: rollback address
output reg 			ID_flush_o;

reg signed [1:0] 	state = 2'b11;

always @(*) begin
	if (~rst_i) begin
		state <= 2'b11;
		state_o <= 2'b11;
		PCSrc_o <= 2'b00;
	end
	else begin
		if (ID_Branch_i && ~EX_Branch_i) begin
			PCSrc_o <= {1'b0, state[1]};
			if (state == 2'b11 || state == 2'b10)
				ID_flush_o <= 1;
			else
				ID_flush_o <= 0;
		end
		else if (EX_Branch_i) begin
			state <= update_i;
			ID_flush_o <= 0;
			if (rbk_i)
				PCSrc_o <= 2'b10;
			else
				PCSrc_o <= 2'b00;
		end
		else if (~ID_Branch_i && ~EX_Branch_i) begin
			PCSrc_o <= 2'b00;
			ID_flush_o <= 0;
		end
		state_o = state;
	end
end

endmodule
