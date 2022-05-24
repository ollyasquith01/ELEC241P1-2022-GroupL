module ATU_tb;
//Set initial variables for angle_tracking_unit.sv
logic [11:0] Q;
logic RESET, PM, MOTORDIRECTION, OPTOA, OPTOB;
//Initialize atu
ATU a1(Q,RESET, PM, MOTORDIRECTION, OPTOA, OPTOB);

/////////////////////////////////////////////////////////////////////////////////
initial begin
OPTOA = 0;
OPTOB = 0;

#500;

OPTOA = 1;
OPTOB = 1;

#500;
	end
	
	

initial begin
	PM = 1;
	MOTORDIRECTION = 1;
	RESET = 0;

	//Initial on startup
	#1 RESET = 1;
	#1 RESET = 0;

	
	
	//1st Test - roughly 90 degrees
	$display("------------");
	$display("TEST 1");	
	
	#15000 assert
	(Q == 12'b000011111100) //252
	$display("PASS %b",Q); 
	
	else 
	$error("FAIL %b",Q);

	
	
	//2nd Test - roughly 270 degrees
	$display("------------");
	$display("TEST 2");
	
	#15000 assert
	(Q == 12'b001011110011) //755
	$display("PASS %b",Q); 
	
	else 
	$error("FAILED %b",Q);	
end


endmodule
