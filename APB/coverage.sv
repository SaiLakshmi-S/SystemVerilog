class coverage;
  
  mailbox #(transaction) mon2cov;
  transaction curr;
  
  
  covergroup cg;
  	option.per_instance =1; //It lets you know how much coverage each covergroup instance achieved individually.
  	
  	op: coverpoint curr.pwrite{
      bins write ={1};
      bins read ={0};
    }
  
  	addr:coverpoint curr.paddr{
      bins first_valid = {0};
      bins valid = {[1:126]};
      bins last_valid = {127};
      bins first_invalid = {128};
      bins invalid = {[129:254]};
      bins last_invalid = {255};
  	}
    
    err: coverpoint curr.pslverr{
      bins fail = {1};
      bins pass = {0};
    }
  
    
  cross op,addr;
  cross op,err;
  endgroup
  
  
  function new(mailbox #(transaction) mon2cov);
    this.mon2cov = mon2cov;
    cg=new();
  endfunction
  
  task run();
    forever 
      begin
        mon2cov.get(curr);
        cg.sample();
      end
  endtask
  
  function void report();
    $display("Coverage percentage: %0.2f%%",cg.get_coverage());
  endfunction
endclass
