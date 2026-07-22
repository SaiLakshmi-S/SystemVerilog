

module Top;
	
	logic PCLK,PRESETn;
	intf intf_inst(PCLK,PRESETn);
	APB_SLAVE DUT(.PWDATA(intf_inst.PWDATA),
		      .PCLK(intf_inst.PCLK),
		      .PRESETn(intf_inst.PRESETn),
		      .PADDR(intf_inst.PADDR),
		      .PWRITE(intf_inst.PWRITE),
		      .PSEL(intf_inst.PSEL),
		      .PENABLE(intf_inst.PENABLE),
		      .PRDATA(intf_inst.PRDATA),
		      .PREADY(intf_inst.PREADY),
		      .PSLVERR(intf_inst.PSLVERR)
		      );
	initial
		begin
			PCLK=0;
			forever #5 PCLK = ~PCLK;
		end

	initial
	begin
		Test ts;
		@(posedge PRESETn)
      ts = new(100,intf_inst.DRIVER,intf_inst.MONITOR);
		ts.run();
	end

	initial 
	begin
		PRESETn = 0;
		#20;
		PRESETn=1;
		#10000;
		$finish;
	end
 
endmodule

