


class Env;
	Generator gen;
	Driver dv;
	Monitor mon;
	Scoreboard sc;
	Coverage cov;
	mailbox #(Txn) g2d, m2s;
	virtual intf.DRIVER vif_d;
	virtual intf.MONITOR vif_m;	
	int n;

	function new(int n,virtual intf.DRIVER vif_d,virtual intf.MONITOR vif_m);
		this.n=n;
		this.vif_d = vif_d;
		this.vif_m = vif_m;
		g2d =new();
		m2s =new();
		cov=new();
		gen = new(g2d,n);
		dv= new(g2d, vif_d,n);
		mon=  new(vif_m,m2s,n,cov);
		sc = new(m2s,n);
	endfunction
	
	task run();
	fork
		gen.run();
		dv.run();
		mon.run();
		sc.run();
	join
		
      cov.report();
	endtask

endclass



