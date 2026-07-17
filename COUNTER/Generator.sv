class Generator;
	Transaction trans;
	mailbox #(Transaction) mbx; // ensure only transaction object is put inside the mailbox
	
	int num_transactions;

	function new(mailbox #(Transaction) mbx, int num_transactions);
		this.mbx=mbx; // the common mailbox is used between generator and driver.
		this.num_transactions=num_transactions;
	endfunction


	task run();
	repeat(num_transactions)
	begin
		trans=new();
		assert(trans.randomize())
		   
		else $fatal("Randomization failed may be due to conflicting constraints");//simultaion stops here
		
		trans.display();
		mbx.put(trans); // sent to the driver

	end

        endtask
endclass
