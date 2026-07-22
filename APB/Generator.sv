class Generator;
	Txn trans;
	int n;
	mailbox #(Txn) gen2drv;

	function new(mailbox #(Txn) gen2drv, int n);
		this.gen2drv = gen2drv;
		this.n=n;
	endfunction
  int valid = (n*3)/4;
	int invalid = n- valid;
	task run();
      repeat(valid)
		begin
		trans= new();
		trans.invalid_addr_c.constraint_mode(0);
		trans.valid_addr_c.constraint_mode(1);
		
		assert(trans.randomize())
		else $fatal("Compilation stopped,check constraints");
		
		trans.display();
		gen2drv.put(trans);
		end

      repeat(invalid)
		begin

		trans= new();
		trans.invalid_addr_c.constraint_mode(1);
		trans.valid_addr_c.constraint_mode(0);
		
		assert(trans.randomize())
		else $fatal("Compilation stopped,check constraints");
		
		trans.display();
		gen2drv.put(trans);

		end
	endtask
endclass


