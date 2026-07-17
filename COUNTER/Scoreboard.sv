class Scoreboard;
	Transaction trans;
	mailbox #(Transaction) m2s;
	logic [3:0] expected_out;
	event all_done;

	int num_transactions=0;
	int pass=0,fail =0;
	function new(mailbox #(Transaction) m2s, int num_transactions);

		expected_out=4'b0000; 
		this.m2s=m2s;
		this.num_transactions= num_transactions;

	endfunction

	task run();
		repeat(num_transactions)
		begin
			m2s.get(trans);
			/*
            
            posedge N-1: driver sets inputs = A
			posedge N:   DUT reads inputs = A (from N-1) → computes out = f(A)
            driver sets inputs = B (for next edge)
			posedge N+1: DUT reads inputs = B → computes out = f(B)
            
            ONE CLOCK CYCLE DELAY BETWEEN DRIVER AND DUT OKAAY

            */
          	
          // comparing trans.out  vs  expected_out (computed LAST iteration that's why first defined before the generating expected out)
          // trans.out is from previous transaction because of one cycle delay between the driver and dut
          	if(^trans.out === 1'bx)begin
				$display("[UNKNOWN] trans.out = %0d at time %0t",trans.out,$time);
			   
			end

			else if( expected_out == trans.out)
			begin
				pass++;
				$display("[PASS] Expected out = %0d, Actual out = %0d ",expected_out,trans.out);
			end
          
			else
              begin
				fail++;
                $display("[fail] Expected out = %0d, Actual out = %0d ",expected_out,trans.out);
              end
          // generating the expected output
			if(trans.rst)
				expected_out = 4'b0000;
			else if(trans.load)
				expected_out = trans.load_data;
			else if(trans.en)
			begin
				if(trans.up_down)
					expected_out =expected_out +1;
				else
					expected_out =expected_out - 1;
			end

		
		


		end

		$display("Total Transaction:%0d",num_transactions);
		$display("PASS : %0d",pass);
		$display("FAIL : %0d",fail);
		
		->all_done;
		
	endtask

endclass

