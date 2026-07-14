class Packet;
  rand bit [3:0] addr;
  rand bit [3:0] data;
  
  function string to_str();
    return  $sformatf("addr= %0d data=%0d" ,addr,data);
  endfunction
  
  
endclass

module tb;
  Packet q[$];
  Packet p;
  
  initial
    begin
      repeat(1000)begin
        p=new();
        void'(p.randomize());
      q.push_back(p);
    end
    
  p= q.pop_front();
      $display("The removed element: %s",p.to_str());
  
  foreach(q[i]) 
    if(q[i].data==p.data && q[i].addr == p.addr)
      $display("exact match found %s",q[i].to_str());
    end
endmodule

