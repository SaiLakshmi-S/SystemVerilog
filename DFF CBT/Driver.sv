

class driver;

virtual dff_if vif;
mailbox mbx;
transaction trans;
int count;

function new(mailbox mbx, virtual dff_if vif);

this.vif =vif;

this.mbx =mbx;

endfunction

task reset;

wait(vif.reset);

  $display("[DRIVER] resetting . . .");

vif.d=0;

wait(!vif.reset);

  $display("reset completed");

endtask

task run;

forever begin

mbx.get(trans);

  @(negedge vif.clk);

vif.d=trans.d;

count++;

end

endtask

endclass
