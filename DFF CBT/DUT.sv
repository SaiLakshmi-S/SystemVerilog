
module DFF (dff_if vif);

always@(posedge vif.clk)
begin

if( vif.reset)

vif.q<= 0;

else

vif.q<= vif.d;

end

endmodule
