
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"

program test(dff_if intf);

environment env;

initial begin

env=new(intf);

env.gen.repeat_count=10;

env.mon.repeat_count=10;

env.run();

end

endprogram
