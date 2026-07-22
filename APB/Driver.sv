class Driver;
	
	mailbox #(Txn) gen2drv;
	virtual intf.DRIVER vif;
	int n;
	function new(mailbox #(Txn) gen2drv, virtual intf.DRIVER vif, int n);
		this.gen2drv =gen2drv;
		this.vif =vif;
		this.n=n;
	endfunction

  task run();
      Txn trans;
		repeat(n)
		begin
			gen2drv.get(trans);

			
			@(vif.drv_cb) // on the next posedge of clk, SETUP

			vif.drv_cb.PADDR<=trans.PADDR;
			vif.drv_cb.PWDATA<=trans.PWDATA;
			vif.drv_cb.PWRITE<=trans.PWRITE;		
			vif.drv_cb.PSEL <=1;
			vif.drv_cb.PENABLE<=0;

			@(vif.drv_cb) //ACCESS
			vif.drv_cb.PENABLE <=1;
  
			

			while(! vif.drv_cb.PREADY) //waiting for the PREADY to be asserted
				@(vif.drv_cb);
		
			@(vif.drv_cb) //IDLE
			vif.drv_cb.PSEL<=0;
			vif.drv_cb.PENABLE<=0;

		//	$display("Sent to DUT");
			
		end
      
	endtask
endclass

