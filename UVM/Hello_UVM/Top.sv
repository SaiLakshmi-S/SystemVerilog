
package my_pck;

	
 	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "Env.sv";
	`include "Test.sv";

endpackage

module top;
   
  import uvm_pkg::*;
  import my_pck::*;
  `include "uvm_macros.svh";
  
  initial
    begin
      run_test("My_test");
    end
endmodule
