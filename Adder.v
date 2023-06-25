module Adder
(
	in,
	amt,
	out,
);

input [31:0]	in;
input [31:0]	amt;
output [31:0]	out;

assign out = in + amt;

endmodule
