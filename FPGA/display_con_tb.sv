module display_con_tb;

//input logic
logic [11:0] angle, clk, write;

//output logic
logic [7:0] data, rs, rw, e;

display_controller o1 (angle, clk, write, data, rs, rw, e);

int counter = 0;            // counter to note the iteration
  
initial begin


angle = 670;               // random angle input for tetsing

// simulate clock cycle

clk = 0; 
  repeat(1000000000000)    // 5000000000000 x 2 = 10000000000000 - 1 second
	#100ps
	clk = ~clk;        // inverts CLK value
	#100ps 
	clk = ~clk;        // larger clock cycles to make it easier too read
  end

always@( posedge clk ) begin    // triggers on positive edge of CLK.

//clear
if (counter == 1)
assert(( rs == 0 ) && ( rw == 0 )) $display( "PASS - pins are 0 and refresh rate 30 hertz" ); else $error( "FAIL - refresh rate error" );
assert( data == 8'b00000001 ) $display("PASS - correct output "); else $error("FAIL - incorrect output");
//digit 1
else if ( counter == 102000 )
assert(( rs == 1 ) && ( rw == 0 )) $display( "PASS - pins are correct d1" ); else $error( "FAIL - pins are incorrect d1" );
assert( data == 6 ) $display("PASS - "); else $error("FAIL - ");
//digit 2
else if ( counter == 104000 )
assert(( rs == 1 ) && ( rw == 0 )) $display( "PASS - pins are correct d2" ); else $error( "FAIL - pins are incorrect d2" );
assert( data == 7 ) $display("PASS - "); else $error("FAIL - ");
//digit 3
else if ( counter == 106000 )
assert(( rs == 1 ) && ( rw == 0 )) $display( "PASS - pins are correct d2" ); else $error( "FAIL - pins are incorrect d2" );
assert( data == 0 ) $display("PASS - "); else $error("FAIL - ");

counter = counter + 1;               // incrament counter each clock cycle

if ( counter == 166666667 )begin     // every 30th of a second. reset counter
counter = 0;
end
				
end
endmodule
