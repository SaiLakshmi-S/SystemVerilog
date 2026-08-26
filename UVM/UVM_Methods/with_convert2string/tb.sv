module tb;
  
  Transaction tx1,tx2;
  
  initial begin
    tx1 = Transaction:: type_id :: create("tx1");
    tx2 = Transaction:: type_id :: create("tx2");
  
  
  tx1.randomize();
  tx2.randomize();
    
    `uvm_info("Txn",tx1.convert2string(),UVM_LOW);
    `uvm_info("Txn",tx2.convert2string(),UVM_LOW);  
 
  end
endmodule
