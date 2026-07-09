
module reverse_arrays();

  int arr[5]= '{2,5,7,9,10};//static arrays
 
	int tmp;
	int n=5;
	initial begin
	
      $display("Before reversing: %p",arr);

		for(int i=0; i<n/2 ;i++)
		begin
			
				tmp=arr[i];
				arr[i]=arr[n-1-i];
				arr[n-1-i]=tmp;
		end

      $display("after reversing: %p",arr);
      arr.reverse();
      $display("Again reversing: %p",arr);
end

endmodule

