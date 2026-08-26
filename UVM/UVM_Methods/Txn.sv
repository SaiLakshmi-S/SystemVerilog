
`include "uvm_macros.svh"
import uvm_pkg::*;

class Transaction extends uvm_object;
  rand bit [3:0] addr;
  rand bit [7:0] wdata;
  rand bit w_en; // 1: write 0: read
  bit [15:0] rdata;
  
  `uvm_object_utils_begin(Transaction)
  `uvm_field_int(addr,UVM_ALL_ON);
  `uvm_field_int(wdata,UVM_ALL_ON);
  `uvm_field_int(w_en,UVM_ALL_ON);
  `uvm_field_int(rdata,UVM_ALL_ON);
  `uvm_object_utils_end
  
  function new(string name="Transaction");
    super.new(name);
  endfunction
  
endclass

module tb;
  
  Transaction tx1,tx2;
  
  initial begin
    tx1 = Transaction:: type_id :: create("tx1");
    tx2 = Transaction:: type_id :: create("tx2");
  
  
  tx1.randomize();
  tx2.randomize();
  
  tx1.print();
  tx2.print();
  
  tx1.copy(tx2);
  tx1.print();
  tx2.print();
  if(tx1.compare(tx2))
    `uvm_info("COMPARE","tx1 and tx2 are same",UVM_LOW)
  else
    `uvm_error("COMPARE","tx1 and tx2 are different")
  
  tx1.randomize();
  tx1.print();
  tx2.print();
  
  $cast(tx1,tx2.clone());
  tx1.print();
  tx2.print();
  if(tx1.compare(tx2))
    `uvm_info("COMPARE","tx1 and tx2 are same",UVM_LOW)
  else
    `uvm_error("COMPARE","tx1 and tx2 are different")
  
  tx1.wdata = 8'b1111_1111;
  tx1.addr = 4'b1010;
  tx1.print();
  tx2.print();
  
  end
endmodule
