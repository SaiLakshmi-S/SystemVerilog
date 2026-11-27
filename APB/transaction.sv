class transaction;
  rand bit [7:0] paddr;
  rand bit [31:0] wdata;
  rand bit pwrite;
  rand int unsigned idle_cycle; // after transfer completes, APB slave goes to idle state if master(driver) say so
  
  bit [31:0] rdata;
  bit pslverr;
  int unsigned wait_cycle;
  constraint c1{
    paddr dist {[0:123] :/85, [124:255] :/15};
  }
  
  constraint c2{
    idle_cycle dist { 0:=1, 1:=3, 2:=6};
  }
  
  function void display(string tag);
    $display("[%0t] %s %s ADDR=%02h, WDATA=%08h, RDATA=%08h, pslverr=%0b waits= %0d", $time, tag, pwrite ? "WR" : "RD", paddr, wdata, rdata, pslverr, wait_cycle);
  endfunction
  
endclass
