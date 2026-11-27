class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sc;
  coverage cv;
  
  mailbox #(transaction) gen2drv,mon2sc,mon2cov;
  virtual apb_intf vif;
  
  function new(virtual apb_intf vif,int random_cnt,int wait_cnt);
    
    this.vif=vif;
    gen2drv=new();
    gen=new(gen2drv, random_cnt);
    
    drv = new(gen2drv, vif);
    
    mon2sc=new();
    mon2cov=new();
    mon=new(mon2sc,mon2cov,vif);
    
    sc=new(mon2sc,wait_cnt);
    cv =new(mon2cov);
    
  endfunction
  
 
  task run();
    drv.reset();
    fork
      drv.run();
      mon.run();
      sc.run();
      cv.run();
    join_none
    
    gen.run();
    wait(gen.total == sc.total);
    repeat(5) @(posedge vif.PCLK);
    
    sc.report();
    cv.report();
  endtask
endclass
