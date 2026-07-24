class My_test extends uvm_test;
  
  `uvm_component_utils(My_test) // registering the class with UVM factory
  
  My_Env envr;
  function new(string name , uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envr = My_Env :: type_id :: create("envr", this );
  endfunction
  
endclass
