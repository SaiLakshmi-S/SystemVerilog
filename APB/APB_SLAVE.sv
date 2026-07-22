module APB_SLAVE(

	input logic [31:0] PWDATA,
	input logic PCLK,
	input logic PRESETn,
	input logic [31:0] PADDR,
	input logic PWRITE,
	input logic PSEL,
	input logic PENABLE,
	output logic [31:0] PRDATA,
	output logic PREADY,
	output logic PSLVERR
	
	);

	logic [31:0] mem [256]; //static array
	typedef enum logic[ 1:0 ]{ 
		IDLE = 2'b00, 
		SETUP = 2'b01,
		ACCESS = 2'b10
    }state_t;
	
	state_t state,nxt_state;
	logic [1:0] wait_cnt;
	always_ff@(posedge PCLK or negedge PRESETn) // active low asynchronous reset 
	begin
		if(!PRESETn) state <= IDLE;
		else state <= nxt_state;
		
	end
	
	always_comb
	begin
		nxt_state = state;
		case(state)
			IDLE: nxt_state = (PSEL)? SETUP : IDLE;
			SETUP: nxt_state =  ACCESS; // after setup,penable is asserted  
       		   	ACCESS: nxt_state = (PREADY)?((PENABLE && PSEL)? SETUP:IDLE ):ACCESS;
          		default: nxt_state = IDLE;
		endcase
	end
	
	assign PREADY = (state == ACCESS && wait_cnt ==0 );
	assign PSLVERR = (state == ACCESS && PADDR >255 && PREADY);
  	always_ff@(posedge PCLK or negedge PRESETn) 
		begin
			if(!PRESETn)
			wait_cnt <=0;
			else if(state == SETUP)
          		wait_cnt <= PWDATA[3:2];
			else if(state == ACCESS && wait_cnt !=0)
			wait_cnt <= wait_cnt -1;
		end
	assign PRDATA = (state == ACCESS && !PWRITE) ? mem[PADDR] : '0;

	always_ff @(posedge PCLK or negedge PRESETn)
	begin
    	if(!PRESETn)
        	;
    	else if(PREADY && !PSLVERR && state == ACCESS && PWRITE)
        	mem[PADDR] <= PWDATA;
	end
  


endmodule


