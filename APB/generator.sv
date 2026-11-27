class generator;
  mailbox #(transaction) gen2drv;
  int unsigned random_cnt;
  int unsigned total;
  transaction trans;
  
  function new (mailbox #(transaction) gen2drv, int random_cnt);
    this.gen2drv =gen2drv;
    this.random_cnt =random_cnt;
  endfunction
  
  task gen(bit [7:0] addr, bit [31:0] data, bit op);
    trans =new();
    if(!trans.randomize() with {paddr == addr; wdata ==data; pwrite == op;})
      $fatal(1,"[GEN] Randomization failed");
    gen2drv.put(trans);
    total++;
  endtask
  
  task run();
    trans = new();
    
    gen(8'b0,32'hAAAA_AAAA,1);//first valid address
    gen(8'h4C,32'h12341234,0 );
    gen(8'h7F,32'hABAB_ABAB,1);//last valid address
    gen(8'b0,32'h0,0);
    gen(8'h80,32'hFAFA_FAFA,1);//write first invalid address
    gen(8'h8C,32'hCAAFCAAF,0);
    gen(8'hFF,32'hBBBB_BBBB,1);//write last invalid address
    gen(8'h7F,32'h0,0);
    gen(8'h80, 32'h0, 0);   // read first invalid
	gen(8'hFF, 32'h0, 0);   // read last invalid
    
    for(int i=0;i<random_cnt;i++)
      begin
        bit [7:0] last_addr;
        trans =new();
        if(i%3 != 2)
          begin
            if(!trans.randomize()with { pwrite == 1; })
              $fatal(1,"[GEN] Randomization failed");
               end
        else 
          begin
            if(!trans.randomize() with {pwrite == 0; paddr == last_addr;})
          		$fatal(1,"[GEN] Randomization failed");
            last_addr = trans.paddr;
        
          end
        gen2drv.put(trans);
        total++;
      end
  endtask
endclass
