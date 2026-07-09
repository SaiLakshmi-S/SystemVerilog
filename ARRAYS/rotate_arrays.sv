// Code your design here

module rotate_arrays;
  
  int dyn[];
  int stat[7]='{3,4,5,6,7,8,15};
  typedef int int_arr[];
  function automatic int_arr right_rotate(input int arr[],int k);
    int n= arr.size();
    int res[];
    k=k%n;
    res = new[arr.size()];
   
    foreach(arr[i])
      res[i]=arr[(i-k+n)%n ];
    return res;
  endfunction
  
  function automatic int_arr left_rotate( input int arr[], int k); //don't forget to put semicon here
    int res[];
    int n= arr.size(); // declaration comes before the execuable statements
    res = new[n];
    
    k=k%n;
    foreach(arr[i])
      res[i]=arr[(i+k)%n];
    return res;
  endfunction
  
  
  int k=2;
  int n=7;
  initial begin
    
  int res[];
  dyn = new[7];
  dyn='{4,6,8,10,14,17,19};
    
    $display("Before rotating, static array:%p",stat);//display always inside procedural blocks
  
  res = left_rotate(stat,k);
    
  $display("after rotating left side, static array:%p",res);
    
  res=right_rotate(stat,k);
    
  $display("after rotating right side, static array:%p",res);
  
  $display("Before rotating, dynamic array:%p",dyn);
  res = left_rotate(dyn,k);
  $display("after rotating left side, dynamic array:%p",res);
  res=right_rotate(dyn,k);
  $display("after rotating right side, dynamic array:%p",res);
  end 
  
endmodule

