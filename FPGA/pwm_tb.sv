module pwm_tb;


logic pwm_out;			// possible to turn the PWM outputs ON or OFF
logic clk;  				// 50MHz clock
logic direction;
logic motorbrake;
logic [7:0] period;
logic [7:0] dutyCycle;
logic motor_direction1;
logic motor_direction2;

pwm_main u1(pwm_out,clk,direction,motorbrake,motor_direction1,motor_direction2);


//initial values 
initial begin
	
	clk = 1;
	 
	 repeat(250)begin
		#60;	//for testing purposes using picoseconds instead of nanoseconds
		clk = ~clk;
		end
end

//inital values


//-------------------------------------------------------------------------------------//	
//TEST - It shall be possible to control the motor to rotate either clockwise or anti-clockwise
//-------------------------------------------------------------------------------------//	

initial begin

	direction = 1;
	 pwm_out = 1;
	 motorbrake = 0;

$display( "test clockwise and anti clockwise motion");

period = 8'b00001000;
dutyCycle = 8'b00000101;

$display( "  ");
$display( "test clockwise");

#1 	assert((motor_direction1==1)&&(motor_direction2==0));
#999	assert((motor_direction1==1)&&(motor_direction2==0))
//#1   	assert((motor_direction1==0)&&(motor_direction2==0))

$display("success - running correcrtly in clockwise direction :) "); else $error("Failure - motor_direction1 = %b - motor_direction2 = %b",motor_direction1, motor_direction2);
$display( "  ");
$display( "test anticlockwise");

direction = 0;

#1 	assert((motor_direction1==0)&&(motor_direction2==1));
#999 	assert((motor_direction1==0)&&(motor_direction2==1))
//#1   	assert((motor_direction1==0)&&(motor_direction2==0))

$display("success - running correcrtly in anticlockwise direction :) "); else $error("Failure - motor_direction1 = %b - motor_direction2 = %b",motor_direction1, motor_direction2);
$display("");
$display( "Test Complete");

//-------------------------------------------------------------------------------------//
//TEST - It should be possible to turn the PWM outputs ON or OF
//-------------------------------------------------------------------------------------//	
$display( "test PWM out can turn on and off ");

#1 	assert((motor_direction1==1)&&(motor_direction2==0))
#150 	assert((motor_direction1==1)&&(motor_direction2==0))

#1 	pwm_out = 0;

#1 	assert((motor_direction1==0)&&(motor_direction2==0))

$display("success - Pwm_Out is off "); else $error("Failure - motor_direction1 = %b - motor_direction2 = %b",motor_direction1, motor_direction2);
$display("");
$display( "Test Complete");


//-------------------------------------------------------------------------------------//
//TEST - it should be possible to perform a brake (all PWM outputs ON)
//-------------------------------------------------------------------------------------//	
	
#1		motorbrake = 0;


#150 	assert((motor_direction1==1)&&(motor_direction2==1))

$display("success - motor brake is high "); else $error("Failure - motor_direction1 = %b - motor_direction2 = %b",motor_direction1, motor_direction2);
$display("");
$display("Test Complete");

end 

endmodule