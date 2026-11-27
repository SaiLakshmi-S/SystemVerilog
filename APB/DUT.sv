module APB_Slave #(parameter DW = 32, 
                   parameter AW = 8,
                   parameter DEPTH = 128, // Depth = 2 ** (ADDR WIDTH) (although maximum depth is 256 and 8 bit address can only represent 256 memory location, I choose to have depth of 128)
                   parameter WAIT_COUNT = 2)//  no of wait count within one tranfer
  (
    input logic PRESETn,
    input logic PCLK,
    input logic [AW-1 :0] PADDR,
    input logic PWRITE,
    input logic  [DW-1 : 0] WDATA,
    input logic PSEL,
    input logic PENABLE,
    output logic PREADY,
    output logic [DW-1 : 0] RDATA,
    output logic PSLVERR
  );
  
  bit [DW-1 : 0] mem[0:DEPTH - 1];
  int unsigned wc;
  bit setup_phase, access_phase;
  bit addr_valid;
  
  always_ff @(posedge PCLK or negedge PRESETn)
    begin
      if(!PRESETn) // Peripherals reset Active Low signal
        wc <= 0;
      else if(setup_phase)
        wc <= WAIT_COUNT;
      else if( access_phase && wc !=0)
        wc <= wc-1;
    end
  
  assign setup_phase = (PSEL && !PENABLE);
  assign access_phase = (PSEL && PENABLE);
  assign PREADY = (access_phase && wc == 0);
  assign addr_valid = (PADDR < DEPTH);
  
  always_ff@(posedge PCLK or negedge PRESETn) //WRITE OPERATION
    begin
      if(!PRESETn) begin
        for(int i=0;i<DEPTH;i++)
          mem[i] <= 32'b0;
      end
      
      else if(PWRITE && access_phase && PREADY && addr_valid)
        mem[PADDR] <= WDATA;
    end
  
  always_comb //READ OPERATION
    begin
      RDATA = 32'b0;
      if(!PWRITE && access_phase && PREADY && addr_valid)
        RDATA = mem[PADDR];
    end
  
  assign PSLVERR = (access_phase && PREADY && !addr_valid);
  
endmodule

