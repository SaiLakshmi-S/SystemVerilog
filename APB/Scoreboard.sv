class Scoreboard;

	mailbox #(Txn) m2s;
	int n,pass,fail,error,writes; 
	bit [31:0] ref_mem [256];

	function new(mailbox #(Txn) m2s,int n);
		this.m2s=m2s;
		this.n=n;
		pass=0;
		fail=0;	
      	error=0;
      	writes=0;
	endfunction

	task run();
      		Txn trans;
		repeat(n)
		begin
			m2s.get(trans);
			
			if(!trans.PREADY) // if slave not ready then ignore the transaction
				continue;
			else if(trans.PSLVERR) // if packet is error then don't compare
				begin	
					error++;
					continue;
                		end

			else if(trans.PWRITE) // write the ref_mem
              		begin
				ref_mem[trans.PADDR] = trans.PWDATA;
               	 		writes++;
              		end
			else
			begin
              			if(ref_mem[trans.PADDR] == trans.PRDATA)begin
					pass++;
                			$display("[PASSED] Expected Data = %0d, Actual Data =%0d",ref_mem[trans.PADDR],trans.PRDATA);
              			end
				else 
				begin
					fail++;
					$display("[FAILED] Expected Data = %0d, Actual Data =%0d",ref_mem[trans.PADDR],trans.PRDATA);
				end
			end

		end
		display();
	endtask
	
	task display();
		$display("SCOREBOARD REPORTS:");
		$display("Total No of Transactions : %0d",n);
		$display("Writes : %0d",writes);
		$display("Errors (PSLVERR) : %0d",error);
		$display("Reads Compared : %0d",pass+fail);
		$display("Pass : %0d",pass);
		$display("Fail : %0d",fail);
	endtask
endclass

