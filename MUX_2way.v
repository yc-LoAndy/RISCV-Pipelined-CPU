module MUX_2way(
	opt0,
	opt1,
	sel_i,
	result_o
);

input [31:0]		opt0;
input [31:0]		opt1;
input 				sel_i;
output [31:0]	result_o;

assign result_o = (sel_i) ? (opt1) : (opt0);

endmodule
