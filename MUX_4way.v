module MUX_4way(
	opt0,
	opt1,
	opt2,
	opt3,
	sel_i,
	result_o
);

input [31:0]			opt0;
input [31:0]			opt1;
input [31:0]			opt2;
input [31:0]			opt3;
input [1:0]				sel_i;
output reg [31:0]		result_o;

always @(*) begin
	case (sel_i)
		2'b00: result_o <= opt0;
		2'b01: result_o <= opt1;
		2'b10: result_o <= opt2;
		2'b11: result_o <= opt3;
	endcase
end

endmodule
