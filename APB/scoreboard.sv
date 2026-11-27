class scoreboard;
  mailbox #(transaction) mon2sc;
  bit [31:0] mem_ref [0:127];
  int total,fail_cnt,pass_cnt;
  int wc;
  
  function new (mailbox #(transaction) mon2sc,int wc);
    this.mon2sc =mon2sc;
    this.wc =wc;
    
    foreach(mem_ref[i]) mem_ref[i] ='0;
  endfunction
  
  
  task run();
    transaction t;
    forever begin
    mon2sc.get(t);
    test(t);
    total++;
    end
    
  endtask
  
  function void test(transaction t);
    int exp_err = t.paddr > 127;
    bit [31:0] exp_rdata='0;    
    int ok=1;
    
    if(!exp_err)
      begin
        if(t.pwrite) mem_ref[t.paddr] = t.wdata;
        else exp_rdata = mem_ref[t.paddr];
      end
    
    
    if(exp_err !== t.pslverr)
      begin
        ok=0;
        $error("[SCB] PSLVERR Mismatch, PADDR = %02h, exp = %0b, actual = %0b",t.paddr,exp_err,t.pslverr);
      end
    
    if( !t.pwrite && t.rdata !== exp_rdata )
      begin
        ok=0;
        $error("[SCB] RDATA Mismatch, PADDR = %02h, exp = %08h, actual = %08h", t.paddr,exp_rdata,t.rdata);
      end
   	
    if(wc != t.wait_cycle)
      begin
        ok=0;
        $error("[SCB] Latency Mismatch, exp_wait = %0d, actual_wait = %0d",wc,t.wait_cycle);
      end
    if(ok) pass_cnt++; else fail_cnt++;
    
   endfunction
  
  function void report();
    $display("_______________________________________");
    $display("Total = %0d, pass = %0d, fail = %0d",total,pass_cnt,fail_cnt);
    if(pass_cnt == total && fail_cnt == 0 )
      $display("Result = PASSED");
    else
      $display("Result = FAILED");
    $display("_______________________________________");
  endfunction
endclass
