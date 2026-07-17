class Env;
	mailbox #(Transaction) g2d,m2s;
	virtual intf vif;

	Generator gen;
	Driver drv;
	monitor mon;
	Scoreboard sc;

	int num_transactions;

	function new(virtual intf vif,int n);
		this.vif=vif;
		num_transactions=n;
		g2d = new();
		m2s =new();
		gen =new(g2d,num_transactions);
		drv =new(g2d,vif,num_transactions);
		mon =new(m2s, vif,num_transactions);
		sc =new(m2s,num_transactions);
	endfunction

	task run();
		fork
			gen.run();
			drv.run();
			mon.run();
			sc.run();
		join_any

		@(sc.all_done);

		$display("VERIFICATION COMPLETED");

		$finish;
	endtask
endclass

