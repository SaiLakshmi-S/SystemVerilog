interface apb_intf(input logic PCLK); 
  logic PRESETn;
  logic [7:0] PADDR;
  logic PWRITE;
  logic [31:0] RDATA,WDATA;
  logic PSEL;
  logic PENABLE;
  logic PREADY;
  logic PSLVERR;
  
  clocking drv_clb@(posedge PCLK);
    default input #1step output #1;
    input PREADY,RDATA,PSLVERR;
    output PRESETn,PADDR,PWRITE,WDATA,PSEL,PENABLE;
  endclocking
  
  clocking mon_clb@(posedge PCLK);
    default input #1step;
   	input PSEL,PENABLE,PADDR,PWRITE,RDATA,WDATA,PREADY,PSLVERR;
  endclocking
  
  //assertions
  
  //checks whether before access, setup phase is present (what if idle ->access happens and setup missed)
  assert property(@(posedge PCLK)
                  disable iff(!PRESETn)
                  $rose(PENABLE) |-> $past((PSEL) && !(PENABLE)) ) 
  else $error("[SVA] Access without a preceding Setup cycle");
  
    //checks whether after setup -> access phase occur (after setup cannot go to idle SO 200% it should be access)
  	assert property(@(posedge PCLK)
                    disable iff(!PRESETn)
                    ((PSEL && !PENABLE) |=> (PSEL && PENABLE)))
   	else $error("[SVA] Setup not followed by Access");
      
      //check whether inputs are stable until the slave is ready
      assert property (@(posedge PCLK)
 						disable iff (!PRESETn)
						  (PSEL && PENABLE) |->($stable(PADDR) && $stable(PWRITE) && (!PWRITE || $stable(WDATA))))
  		else $error("[SVA] PADDR/PWRITE/PWDATA changed between Setup and completion");
      
        //check if access phase with psel and penable high
      	assert property (@(posedge PCLK)
                         disable iff(!PRESETn)
                         (PREADY |-> PSEL && PENABLE)
                        )
          else $error("[SVA] DUT raised PREADY outside Access phase");
  
        //check if error signal is functioning properly in ACCESS STATE
        assert property(@(posedge PCLK)
                        disable iff(!PRESETn)
                        (PSEL && PENABLE && PREADY |->(PSLVERR == ( PADDR > 127 ))))
        else $error("[SVA] PSLVERR does not match address range");
        
        
        //check if after access state and transfer complete whether it does not start the next transfer from the access phase
        assert property(@(posedge PCLK)
                        disable iff (!PRESETn)
                          ((PSEL && PENABLE && PREADY) |=> (!PENABLE))
                         )
        else $error("[SVA] PENABLE stayed high after transfer completed");
        
          
          c_wait_state: cover property (@(posedge PCLK) disable iff (!PRESETn)
    PSEL && PENABLE && !PREADY);
  c_back_to_back: cover property (@(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && PREADY) ##1 (PSEL && !PENABLE));
endinterface
          
