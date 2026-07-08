module MUX_4x1 (
	input i1,i2,i3,i4,sel1,sel2,
	output logic out);

	always_comb
	begin
		case({sel1,sel2})
			2'b00:out=i1;
			2'b01:out=i2;
			2'b10:out=i3;
			2'b11:out=i4;
		endcase
	end
	endmodule

module tb;

logic i0,i1,i2,i3,s0,s1,out;

MUX_4x1 dut(i0,i1,i2,i3,s0,s1,out);

initial begin
	$monitor("At %t time, i0=%d i1=%d i2=%d i3=%d s0=%d s1=%d out=%d",$time,i0,i1,i2,i3,s0,s1,out);
	#2 i0=0;i1=0;i2=0;i3=0;s0=0;s1=0;
	#2 i0=1;i1=0;i2=0;i3=0;s0=0;s1=0;
	#2 i0=0;i1=1;i2=0;i3=0;s0=1;s1=0;
        #2 i0=0;i1=0;i2=1;i3=0;s0=0;s1=1;
        #2 i0=0;i1=0;i2=0;i3=1;s0=1;s1=1;
        #2 i0=0;i1=1;i2=1;i3=0;s0=0;s1=0;
	#10 $finish;


end

endmodule

