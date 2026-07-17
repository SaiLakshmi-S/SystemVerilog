class Test;
	Env env;
	virtual intf vif;

	function new( virtual intf vif,int n );
		this.vif=vif;
		env = new(vif,n);
	endfunction
	
	task run();
		$display("Starting Counter Verification....");
		env.run();
	endtask
endclass
