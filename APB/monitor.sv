class monitor;
  
  mailbox #(transaction) mon2sc,mon2cov;
  virtual apb_intf vif;
  transaction t;
  
  function new(mailbox #(transaction) mon2sc,mailbox #(transaction) mon2cov ,virtual apb_intf vif);
    this.mon2sc=mon2sc;
    this.mon2cov=mon2cov;
    this.vif=vif;
  endfunction
  
  task run();
    int wc=0;
    transaction t;
    forever
      begin
        @(vif.mon_clb);
        if(!vif.PRESETn)
          wc=0;
        else if (vif.mon_clb.PSEL && vif.mon_clb.PENABLE)begin
          if(vif.mon_clb.PREADY)begin   
        	t=new();
        	t.paddr = vif.mon_clb.PADDR;
        	t.pwrite = vif.mon_clb.PWRITE;
        	t.wdata = vif.mon_clb.WDATA;
        	t.rdata = vif.mon_clb.RDATA;
        	t.pslverr = vif.mon_clb.PSLVERR;
        	t.wait_cycle = wc;
            
            wc=0;
        	mon2sc.put(t);
        	mon2cov.put(t);
          end
          else
            wc++;
        end
      end
  endtask
  
endclass
