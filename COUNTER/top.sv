import txn_pkg::*;


module top;

	intf intf_inst();
	Test test;

	sync_counter dut(
		.clk(intf_inst.clk),
		.load(intf_inst.load),
		.load_data(intf_inst.load_data),
		.up_down(intf_inst.up_down),
		.rst(intf_inst.rst),
		.en(intf_inst.en),
		.out(intf_inst.out)
		);

	initial begin
		intf_inst.clk = 0;
		forever #5 intf_inst.clk = ~intf_inst.clk;

	end
	
	initial begin
		test =new(intf_inst,100);
		test.run();
	end
	

endmodule
