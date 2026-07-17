class monitor;
	Transaction trans;
	mailbox #(Transaction) m2s;
	virtual intf vif;
	int num_transactions;
	function new ( mailbox #(Transaction ) m2s,virtual intf vif, int n);
		this.vif=vif;
		this.m2s=m2s;
		num_transactions=n;
	endfunction

	task run();
		repeat(num_transactions)
		begin
			trans=new();

			@(vif.mon_cb)
			begin
				trans.load = vif.mon_cb.load;
				trans.load_data = vif.mon_cb.load_data;
				trans.en = vif.mon_cb.en;
				trans.rst = vif.mon_cb.rst;
				trans.up_down = vif.mon_cb.up_down;
				trans.out = vif.mon_cb.out;

			end
			$display("Monitor captured transaction");
			trans.display();
			m2s.put(trans);

			$display("Transaction sent to scoreboard");
		end


	endtask
endclass


