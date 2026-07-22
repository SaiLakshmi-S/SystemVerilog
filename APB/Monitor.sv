
class Monitor;

	virtual intf.MONITOR vif;
	mailbox #(Txn) m2s;
	int n,cnt=0;
	Coverage cov;

	function new(virtual intf.MONITOR vif,mailbox #(Txn) m2s,int n,Coverage cov);
		this.vif=vif;
		this.m2s=m2s;
		this.n=n;
		this.cov =cov;
	endfunction
	
  task run();
      Txn trans;
			while(cnt<n)begin
			@(vif.mon_cb)

			if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE)//ensuring it is in access state
			begin
			
				while(!vif.mon_cb.PREADY) // ensuring slave is ready
					@(vif.mon_cb);
			trans=new();
			trans.PWDATA = vif.mon_cb.PWDATA;
			trans.PWRITE = vif.mon_cb.PWRITE;
			trans.PREADY = vif.mon_cb.PREADY;
			trans.PRDATA = vif.mon_cb.PRDATA;
			trans.PSLVERR = vif.mon_cb.PSLVERR;
			trans.PADDR = vif.mon_cb.PADDR;

			m2s.put(trans);
		  	cov.sample(trans);
			cnt++;
            	  	$display("[%0t] MON: Addr=%0d PREADY=%0b PRDATA=%0d",$time,
         		vif.mon_cb.PADDR,
        		vif.mon_cb.PREADY,
         		vif.mon_cb.PRDATA);
			end
		        end
	endtask

endclass


