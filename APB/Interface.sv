interface intf(	input logic PCLK, input logic PRESETn);
	
	 logic [31:0] PWDATA;
	 logic [31:0] PADDR;
	 logic PWRITE;
	 logic PSEL;
	 logic PENABLE;
	 logic [31:0] PRDATA;
	 logic PREADY;
	 logic PSLVERR;
	
  	 initial begin
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        PADDR   = 0;
        PWDATA  = 0;
    end
	 clocking drv_cb@(posedge PCLK);
		 default input#1 output#0;
		 input PREADY,PSLVERR,PRDATA;
		 output PWDATA,PADDR,PWRITE,PSEL,PENABLE;
	 endclocking
	
	 clocking mon_cb@(posedge PCLK);
		default input#1;
		input   PREADY,PSLVERR,PRDATA,PWDATA,PADDR,PWRITE,PSEL,PENABLE;

	 endclocking
	 
	 modport DRIVER (clocking drv_cb, input PCLK, PRESETn);
	 modport MONITOR (clocking mon_cb, input PCLK ,PRESETn);
endinterface


