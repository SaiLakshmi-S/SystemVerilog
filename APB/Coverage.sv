class Coverage;

	Txn trans;

	covergroup cg;
		cp_write: coverpoint trans.PWRITE;
		cp_addr: coverpoint trans.PADDR{
			bins low={[0:63]};
			bins mid={[64:127]};
			bins high={[128:255]};
            bins err={[256:$]};
			}
		cross cp_write, cp_addr;

	endgroup

	function new();
		cg = new();
	endfunction

	function void sample(Txn t);
		trans=t;
		cg.sample();

	endfunction
  
    function void report();
     	$display("Coverage = %0.2f%%", cg.get_coverage());
    endfunction
endclass

