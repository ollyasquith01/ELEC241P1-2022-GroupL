module display_controller (
   output logic [7:0] data,
   output logic rs,
   output logic rw,
   output logic e,
   input logic [7:0] ascii_data,
	input logic [11:0] angle,
   input logic write,
   input logic clk);
	
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

reg [11:0] angleinternal;		// saves the angle in an internal variable 
reg [11:0] degrees;     	   // to save angleinternal as degrees
reg [11:0] BCD;        		   // BCD, Binary coded decimal
reg [7:0] ascii_d1;           // ascii conversion digit 1 
reg [7:0] ascii_d2;           // ascii conversion digit 2
reg [7:0] ascii_d3;           // ascii conversion digit 3
reg [21:0] refreshrate = 0;   // 22 bit referesh rate lets us go to 30hz 


// LCD refresh rate /////////////////////////////////////////////////////////////////////////////////////////

always@( posedge clk )begin              // always checks on positive edge of clock

refreshrate = refreshrate + 1;           // increase every posedge
	if ( refreshrate == 3333333 )begin    // refreshes angle at 30 hz, on a 50Mhz clock (50Mhz/30 * 2) = 3333333
		angleinternal = angle;             // update angle internal
		refreshrate = 0;                   // reset rate
	end

end
 
// converting values ////////////////////////////////////////////////////////////////////////////////////////

always_comb begin              // executes on signal change and at zero                                     

// converting angles to degrees
degrees = ( angleinternal * 360 )/1006;                              // covert to intervals of 360
	if((( angleinternal * 360 ) - ( degrees * 1006 )) > 500 )begin    // round to nearest whole number 
	 degrees = degrees + 1;
	end 
	                                                                  //      1           2           3       eg. 0001 0011 0101 = 135 degrees   
// converting degrees to BCD                                         // [ 0 0 0 0 ] [ 0 0 0 0 ] [ 0 0 0 0 ]               
BCD [11:8] = degrees / 100;		                   						// first digit of the BCD in the hundreths 
BCD [7:4] = ( degrees - ( BCD [11:8] * 100 ))/10;   						// second digit of BCD in the tens, by getting rid of the hundreths digit
BCD [3:0] = ( degrees - ( BCD [11:8] * 100 ) - ( BCD [7:4] * 10 ));  // third digit in ones, by removing thr tens and hundreths

// BCD to ascii
ascii_d1 = BCD [11:8] + 48;  	 // digit 1, adding 48 as asscii 0 is decimal 48
ascii_d2 = BCD [7:4] + 48;     // digit 2
ascii_d3 = BCD [3:0] + 48;     // digit 3

end

// writing to lcd ///////////////////////////////////////////////////////////////////////////////////////////

always @( angleinternal )begin        // always on a change of angleinternal

	// clear lcd
	rs = 0;               				  // rs = 0 so commanmd is sent
	rw = 0;               			  	  // rw = 0 so write to lcd
	data = 8'b00000001;    				  //
	e = 1;                             // enable pin high
	wait( refreshrate == 1000 );   	  // wait 20 us
	e = 0;									  // toggle e to low
	wait( refreshrate == 101000 );  	  // wait 2 millesecond for screen to clear , stated in lcd_setup 
	
	// write digit 1, 100s, to lcd
	rs = 1;                            // rs = 1 so data is sent
	rw = 0;                            // rw = 0 so write to lcd
	data = ascii_d1;                   // write digit 1 to lcd
	e = 1;
	wait( refreshrate == 102000 );     // wait 20 us
	e = 0;									  // toggle e to low
	wait( refreshrate == 103000 ); 	  // wait 20 us
	
	// write digit 2, 10s, to lcd
	rs = 1;                            // rs = 1 so data is sent
	rw = 0;                            // rw = 0 so write to lcd
	data = ascii_d2;                   // write digit 2 to lcd
	e = 1;
	wait( refreshrate == 104000 );     // wait 20 us
	e = 0;									  // toggle e to low
	wait( refreshrate == 105000 ); 	  // wait 20 us
	
	// write digit 2, 10s, to lcd
	rs = 1;                            // rs = 1 so data is sent
	rw = 0;                            // rw = 0 so write to lcd
	data = ascii_d3;                   // write digit 3 to lcd
	e = 1;
	wait( refreshrate == 106000 );     // wait 20 us
	e = 0;									  // toggle e to low
	wait( refreshrate == 107000 );  	  // wait 20 us
	
end
   
endmodule
   
