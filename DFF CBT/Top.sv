// Code your testbench here
// or browse Examples
`include "interface.sv"
`include "test.sv"

module top;

dff_if intf();

test tst(intf);

DFF dut(intf);

initial begin

intf.clk =0;

forever #5 intf.clk=~intf.clk;

end

initial begin

intf.reset = 0;

#2 intf.reset=1;

#10;

intf.reset = 0;

end

initial begin
$dumpfile("dump.vcd");
$dumpvars;
end

endmodule
