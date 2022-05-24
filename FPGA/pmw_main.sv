module pwm_main ( 
input  logic pwm_out,
input  logic clk,  
input  logic direction,
input  logic motorbrake,
input  logic [7:0] period,
input  logic [7:0] dutyCycle,
output logic motor_direction1,
output logic motor_direction2);



// start internals 


int counter = 0;



always @(posedge clk) begin

if (motorbrake == 1)begin									// Run break command when motor directions are high 

	motor_direction1 = 1;
	motor_direction2 = 1;
end	
	
if((pwm_out == 0)&&(motorbrake == 0))begin 	//when pwm is low motors are low
		
	motor_direction1 = 0;								
	motor_direction2 = 0;
end	

	
if ((pwm_out == 1)&&(motorbrake == 0))begin
		if ((counter < period-1)&&(pwm_out == 1))begin
		
			if((counter == 0)&&((motor_direction1 == 1)||(motor_direction2 == 1)))
				counter = counter +1;
			if(counter != 0)
				counter = counter + 1;
			end
end
counter = 0;
			
		  //CLOCKWISE MODE
		if (direction == 1)begin
			
			motor_direction1 = (counter < dutyCycle) ? 1:0;		// Run clockwise for high
			motor_direction2 = 0;
		end	
		
		//ANTICLOCKWISE MODE
		if  (direction == 0)begin
			
			motor_direction2  = (counter < dutyCycle) ? 1:0;	// Run anticlockwise for high
			motor_direction1 = 0;
			
		end

end
endmodule