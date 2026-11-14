




class generator;

event ended;

mailbox mbx;

transaction trans;

int repeat_count;

function new(mailbox mbx);

this.mbx=mbx;

endfunction

task run;

repeat(repeat_count)

begin

trans =new();

if(!trans.randomize())

  $fatal(1,"Randomization failed");

mbx.put(trans);

end

 -> ended;

endtask

endclass
