
class environment;

generator gen;

driver drv;

monitor mon;

scoreboard sb;

mailbox gen2drv;

mailbox mon2sb;

virtual dff_if vif;

function new(virtual dff_if vif);

this.vif=vif;

gen2drv=new();

mon2sb=new();

gen= new(gen2drv);

drv=new(gen2drv,vif);

mon=new(mon2sb,vif);

sb=new(mon2sb);

endfunction

task pre_run();

drv.reset();

endtask

task main();

fork

gen.run();

drv.run();

mon.run();

sb.run();

join_any

endtask

task post_run();

wait(gen.ended.triggered);

wait(gen.repeat_count == drv.count);

wait(mon.repeat_count == sb.count);

endtask

task run();

pre_run();

main();

post_run();

endtask

endclass
