module directionLineLogic (
	input logic clk,
	//input logic resetN,

	input logic key2IsPressed,
	input logic key4IsPressed,
	input logic key6IsPressed,
	input logic key8IsPressed,
	input logic keyEnterIsPressed,
	
	output logic signed [10:0] newVelocityX,
	output logic signed [10:0] newVelocityY,
	output logic velocityWriteEnable
);

int velocityX=0, velocityY=0;
	

//getting the new velocities	
always_ff @(posedge clk)// or negedge resetN)
begin	

	/*if(!resetN) begin
		newVelocityX <= 11'b0; 
		newVelocityY <= 11'b0;
		velocityWriteEnable <= 0;	
	end*/
	
	//defaults
	newVelocityX <= velocityX; 
	newVelocityY <= velocityY;
	velocityWriteEnable <= 0;
	
	if(key2IsPressed) begin
		velocityY <= velocityY - 1;
	end
	
	else if(key8IsPressed) begin
		velocityY <= velocityY + 1;
	end
	
	else if(key4IsPressed) begin
		velocityX <= velocityX - 1;
	end
	
	else if(key6IsPressed) begin
		velocityX <= velocityX + 1;
	end
	
	else if(keyEnterIsPressed) begin
		newVelocityX <= velocityX;
		newVelocityY <= velocityY;
		velocityWriteEnable <= 1;
	end
	
end 
//TRANFER TO LINELOGIC	
//calculating the end point of the arrow/line
//	lineTopLeftPosX <= ballTopLeftPosX + newVelocityX;
//	lineTopLeftPosY <= ballTopLeftPosY + newVelocityY;

endmodule 