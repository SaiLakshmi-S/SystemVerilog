
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
  
  function string convert2string();
    return $sformatf("addr = %0h, wdata = %0h, w_en = %0b",addr,wdata,w_en);
  endfunction
  
endclass
