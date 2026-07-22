class Txn;

	rand  bit [31:0] PWDATA;
	rand  bit [31:0] PADDR;
	rand  bit PWRITE;
/*	rand  bit PSEL;  NOT NEEDED Because driver controls APB protocol
	rand  bit PENABLE;    */
	bit [31:0] PRDATA;         
	bit PREADY;
	bit PSLVERR;

	constraint valid_addr_c{
		PADDR inside {[0:255]}; //inside constraint
		};
	constraint invalid_addr_c{
		PADDR > 255; //expression constraint
		};
  /*
	constraint r_w_OP{
		PWRITE dist {1:= 75 , 0:=25};
		//PRESETn dist {0:=10 ,1:=90}; u don't randomize the rst for every transaction it managed by the test/top

		};
        */
	function void display();
		$display("[%0t] addr =%0d, wdata =%0d, write =%0b, rdata =%0d, pready =%0d, Pslave_error=%0d ",$time,PADDR,PWDATA,PWRITE,PRDATA,PREADY,PSLVERR);
	endfunction
endclass


