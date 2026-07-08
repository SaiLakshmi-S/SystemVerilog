module Dff(input logic d, logic clk, logic reset_n, output logic q);

always_ff@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		q<=1'b0;
	else
		q<=d;
end
endmodule

module tb;

logic d,clk,reset_n,q;
Dff dut(d,clk,reset_n,q);

initial begin
	clk=0;
forever
#2 clk= ~clk;
end

initial 
begin
	reset_n=0;
	$monitor("At %t time,d=%d q=%d",$time, d,q);
	#2 reset_n=1; d=0;
	#2 d=1;
	#2 d=0;
	#5 d=1;
	#10 $finish;
	
end
endmodule
