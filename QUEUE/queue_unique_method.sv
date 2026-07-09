module built_in_unique;
  int dyn[];
  int q[$];
  int unique_q[$];
  initial
    begin
      dyn=new[10];
      dyn='{2,7,8,9,11,17,18,2,8,9};
      
      foreach(dyn[i])
        q.push_back(dyn[i]);
      q.sort(); //optional just for ordering
      unique_q=q.unique();//just print the unique elements
      $display("unique elements:%p",unique_q);
      
    end
endmodule


