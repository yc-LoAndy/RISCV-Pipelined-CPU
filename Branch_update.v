module Branch_update(
	clk_i,
	rst_i,
	Zero_i,
	EX_Branch_i,
	state_i,
	rbk_o,
	ID_flush_o,
	EX_flush_o,
	update_o
);

input				clk_i, rst_i;
input				Zero_i;
input 				EX_Branch_i;
input [1:0]			state_i;
output reg			rbk_o;
output reg			ID_flush_o;
output reg			EX_flush_o;
output reg [1:0] 	update_o;

always @(*) begin
	if (~rst_i) begin
		rbk_o <= 0;
		ID_flush_o <= 0; EX_flush_o <= 0;
		update_o <= 2'b11;
	end
	else if (EX_Branch_i) begin
		if (Zero_i == 1 && (state_i == 2'b01 || state_i == 2'b00)) begin	// Wrong pred
			rbk_o <= 1;
			ID_flush_o <= 1; EX_flush_o <= 1;
			if (state_i == 2'b01)
				update_o <= 2'b10;
			else if (state_i == 2'b00)
				update_o <= 2'b01;
		end
		else if (Zero_i == 0 && (state_i == 2'b10 || state_i == 2'b11)) begin	// Wrong pred
			rbk_o <= 1;
			ID_flush_o <= 1; EX_flush_o <= 0;
			if (state_i == 2'b10)
				update_o <= 2'b01;
			else if (state_i == 2'b11)
				update_o <= 2'b10;
		end
		else if (Zero_i == 1 && (state_i == 2'b10 || state_i == 2'b11)) begin	// correct pred
			rbk_o <= 0;
			ID_flush_o <= 0; EX_flush_o <= 0;
			if (state_i == 2'b10)
				update_o <= 2'b11;
			else if (state_i == 2'b11)
				update_o <= 2'b11;
		end
		else if (Zero_i == 0 && (state_i == 2'b01 || state_i == 2'b00)) begin	// correct pred
			rbk_o <= 0;
			ID_flush_o <= 0; EX_flush_o <= 0;
			if (state_i == 2'b01)
				update_o <= 2'b00;
			else if (state_i == 2'b00)
				update_o <= 2'b00;
		end
	end
	else begin
		rbk_o <= 0;
		ID_flush_o <= 0; EX_flush_o <= 0;
		update_o <= state_i;
	end
end

endmodule
