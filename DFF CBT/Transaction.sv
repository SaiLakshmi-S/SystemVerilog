class transaction;

rand bit d;

logic q;

logic reset;

logic clk;

function void disp(string str);

  $display("%s",str);

  $display("d= %d, q=%d", d, q);

endfunction

endclass
