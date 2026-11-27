//TOP

`include "transaction.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"

module top;
  
  localparam WAIT_CNT =2;
  
  logic PCLK;
  environment env;
  initial begin
    PCLK=0;
    forever #5 PCLK = ~PCLK; 
  end
  
  apb_intf intf(PCLK);
  
  initial begin
    env = new(intf, 100, WAIT_CNT);
    env.run();
    $finish;
  end
  
  APB_Slave #(.DW(32),
              .AW(8),
              .DEPTH(128),
              .WAIT_COUNT(WAIT_CNT))
  
  DUT(
    .PRESETn(intf.PRESETn),
    .PCLK(PCLK),
    .PADDR(intf.PADDR),
    .PWRITE(intf.PWRITE),
    .WDATA(intf.WDATA),
    .PSEL(intf.PSEL),
    .PENABLE(intf.PENABLE),
    .PREADY(intf.PREADY),
    .RDATA(intf.RDATA),
    .PSLVERR(intf.PSLVERR)
  );
  
  //watchdog
  
  initial begin
    #1000000;
    $fatal(1,"[TB] Timeout - simulation hung");
  end
  
  initial begin
    $dumpfile("DUMP.vcd");
    $dumpvars(0,top);
  end
endmodule

