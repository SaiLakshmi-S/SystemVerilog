


class monitor;

transaction trans;

mailbox mon2sb;

virtual dff_if vif;

int repeat_count;

function new( mailbox mon2sb, virtual dff_if vif);

this.mon2sb = mon2sb;

this.vif=vif;

endfunction

task run;

repeat(repeat_count)

begin

trans = new();
  @(posedge vif.clk);
trans.d=vif.d;

trans.q=vif.q;

mon2sb.put(trans);

end

endtask

endclass
