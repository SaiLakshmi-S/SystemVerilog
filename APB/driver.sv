class driver;
  
  mailbox #(transaction) gen2drv;
  virtual apb_intf vif;
  transaction t;
  
  function new (mailbox #(transaction) gen2drv, virtual apb_intf vif);
    this.gen2drv= gen2drv;
    this.vif= vif;
  endfunction
  
  task reset();
    vif.PRESETn<=1'b0;
    vif.drv_clb.PADDR<=8'b0;
    vif.drv_clb.WDATA<=32'b0;
    vif.drv_clb.PWRITE<=32'b0;
    vif.drv_clb.PSEL<=0;
    vif.drv_clb.PENABLE<=0;
    
    repeat(3) @(vif.drv_clb);
    vif.PRESETn<=1'b1;
    @(vif.drv_clb);
  endtask
  
  task run();
    forever
      begin
      gen2drv.get(t);
      drive(t);
      end
      
  endtask
  
  task drive(transaction t);
     
    vif.drv_clb.PSEL<=1;
    vif.drv_clb.PENABLE<=0;
    vif.drv_clb.PADDR<=t.paddr;
    vif.drv_clb.WDATA<=t.wdata;
    vif.drv_clb.PWRITE<=t.pwrite;

    @(vif.drv_clb);
    vif.drv_clb.PENABLE<=1;
    
    while(!vif.drv_clb.PREADY)
      @(vif.drv_clb);
      
    if( t.idle_cycle >0 || gen2drv.num() == 0 )begin
        vif.drv_clb.PSEL <= 1'b0;
    	vif.drv_clb.PENABLE <= 1'b0;
      repeat(t.idle_cycle) @(vif.drv_clb);
      end
    
  endtask
  
endclass
