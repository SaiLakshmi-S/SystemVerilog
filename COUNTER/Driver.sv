class Driver;
	Transaction trans;
	mailbox #(Transaction) mbx;
	virtual intf vif;
	int num_transactions;

	function new(mailbox #(Transaction) mbx, virtual intf vif,int n);
		this.mbx=mbx;
		this.vif=vif;
		num_transactions =n;
	endfunction

	task run();

		repeat(num_transactions)
		begin
			mbx.get(trans); 
			$display("Received Transaction");
			trans.display();

          @(posedge vif.clk) // Wait for the next driver clocking event (posedge clk), then drive DUT inputs
		
			vif.rst <=trans.rst;
			vif.en <=trans.en;
			vif.load <=trans.load;
			vif.up_down <=trans.up_down;
			vif.load_data <=trans.load_data;
			
			$display("convert the packets into pin level data and sent to DUT");
		end
	endtask
endclass

