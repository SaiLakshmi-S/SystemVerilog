interface intf;
	logic clk,rst,en,load,up_down;
	logic [3:0] load_data,out;

	/*
    NOT NEEDED BECOZ THE ALL SIGNALS CAN GO AT POSEDGE NO ISSUES
    clocking drv_cb@(posedge clk);
		default input #1step output #0; 

		output rst,en,load,up_down,load_data;
		input out; // out is given with 1step delay because to avoid the race condition Therefore the driver reads the stable value produced by the DUT.
	endclocking
    */

  clocking mon_cb@(posedge clk);

		default input #1step; // sample signals one simulator step after the clock edge
		input rst,en,load,up_down,load_data,out; // Therefore the DUT updates before the monitor reads the values
	endclocking
endinterface

