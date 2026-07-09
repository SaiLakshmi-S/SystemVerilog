module dup;
  
  int arr[10]='{6,45,78,87,65,45,92,79,92,36}; //static
  int count[int];//associative
  initial begin
  foreach(arr[i])
    count[arr[i]]++;
  
  
  foreach(count[k])
    begin
      if(count[k]>1)
        $display("duplicate element: %0d.\nNo of times: %0d",k,count[k]);
      
    end
  end
 endmodule
        
