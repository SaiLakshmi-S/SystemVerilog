module sync_counter(input clk,rst,en,up_down,load, input [3:0] load_data, output logic [3:0] out );

always_ff@(posedge clk )
begin
	if(rst)
		out<=4'b0000;
	else if(load)
		out<=load_data;
	else if(en )begin
	if( up_down)
		out<=out+1;
	else
		out<=out-1;
		end
	else
		out<=out;

end

endmodule

