module ATU(output logic  [11:0] Q, 
input logic RESET, PM,DIRECTION,OPTOA,OPTOB);


always_latch begin
	//RESET fn
	if(RESET == 1) //Will only start when reset is low
		Q = 0;
		
	//PULSE MONITORING TOGGLE
	else if(PM == 1)begin
	
		//DIRECTION FUNCTION AND ANGLE TRACKING 
		if ((DIRECTION == 1'b1)&&(OPTOA == 1)&&(OPTOB == 0))
		
		begin //If direction is clockwise, increase pulse count
		Q = Q + 1;
			if (Q == 1006)		   //Prevents angle being greater than 360
					Q = 0;			//when angle reaches 360 then set it to 0
			end
			else if ((DIRECTION == 0)&&(OPTOA == 0)&&(OPTOB == 1))begin //If direction is anticlockwise on pulse decrease pulse count
				Q = Q - 1;
				if (Q == 4095)		//So that there is no negative angle
					Q = 1005;		//loops back to roughly 360 degrees
			end
	end
end
endmodule
