

class Test;
	Env env;
	int n;
	virtual intf.DRIVER vif_d;
	virtual intf.MONITOR vif_m;

	function new(int n,virtual intf.DRIVER vif_d,virtual intf.MONITOR vif_m);
		this.vif_d=vif_d;
		this.vif_m=vif_m;
		this.n=n;
		env=new(n,vif_d,vif_m);

	endfunction

	task run();
		env.run();
	endtask
endclass

