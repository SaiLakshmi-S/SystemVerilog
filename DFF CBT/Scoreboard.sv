
class scoreboard;

mailbox mon2sb;
int failed_count;

int count;

transaction trans;

function new(mailbox mon2sb);

this.mon2sb=mon2sb;

endfunction

task run;

forever

begin

mon2sb.get(trans);
  count++;
  if(trans.d!=trans.q)

begin
failed_count++;

  $display("[%d]FAILED at %0t , q =%d , d =%d",failed_count,$time, trans.q,trans.d);

end
  else
    $display("[%0d]PASSED at %0t time, Expected=%0b, Actual=%0b",count - failed_count, $time,trans.d, trans.q);


end

endtask

endclass
