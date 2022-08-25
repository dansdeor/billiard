module ball_logic (
					input logic clk,
					input logic resetN,
					input logic startOfFrame,
					
					input logic velocityWriteEnable,
					input logic signed [10:0] invelocityX,
					input logic signed [10:0] invelocityY,
					
					output logic signed [10:0] topLeftX_position,
					output logic signed [10:0] topLeftY_position,
					
					output logic signed [10:0] outvelocityX,
					output logic signed [10:0] outvelocityY
					
);

parameter int INITIAL_Y_velocity = 0;
parameter int INITIAL_X_velocity = 0;
parameter int INITIAL_Y_position = 0;
parameter int INITIAL_X_position = 0;
parameter int velocityY_ACCEL = 0;
parameter int velocityX_ACCEL = 0;
int velocityX, topLeftXInt;
int velocityY, topLeftYInt;
const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
//const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
//const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

// Y_direction_moves
always_ff @(posedge clk or negedge resetN)
begin	
	if(!resetN) begin 
		velocityY <= INITIAL_Y_velocity;
		topLeftYInt	<= INITIAL_Y_position * FIXED_POINT_MULTIPLIER;
	end
	
	//for collision, the collision velocity we get from our cotroller
	else if(velocityWriteEnable) begin
			velocityY <= invelocityY;
	end
	
	
	// perform  position and velocity integral only when a new frame starts
	else if (startOfFrame) begin
	
		topLeftYInt  <= (topLeftYInt + velocityY);// position interpolation 
		//TODO : MAKE SURE THAT THE BALL ISN'T ON THE EDGES AFTER THE CHANGE!!!
		if (velocityY > 0) begin
			velocityY <= velocityY - velocityY_ACCEL;
			if(velocityY < 0)
				velocityY <= 0;
		end
		
		else if (velocityY < 0) begin
			velocityY <= velocityY + velocityY_ACCEL;
			if(velocityY > 0)
				velocityY <= 0;
		end
	end	
end 

// X_direction_moves
always_ff @(posedge clk or negedge resetN)
begin	
	if(!resetN) begin 
		velocityX	<= INITIAL_X_velocity;
		topLeftXInt	<= INITIAL_X_position * FIXED_POINT_MULTIPLIER;
	end
	
	//for collision, the collision velocity we get from our cotroller
	else if(velocityWriteEnable) begin
			velocityX <= invelocityX;
			end
	// perform  position and velocity integral only when a new frame starts
	else if (startOfFrame) begin
		
		topLeftXInt  <= (topLeftXInt + velocityX);	// position interpolation 
		//TODO : MAKE SURE THAT THE BALL ISN'T ON THE EDGES AFTER THE CHANGE!!!
		
		if (velocityX > 0) begin
			velocityX	<= velocityX - velocityX_ACCEL;
			if(velocityX < 0)
				velocityX <= 0;
		end
			
		else if (velocityX < 0) begin
			velocityX	<= velocityX + velocityX_ACCEL;
			if(velocityX > 0)
				velocityX <= 0;
		end
	end	
end 

/*always_ff @(posedge clk or negedge resetN) begin

	if(velocityWriteEnable) begin
		velocityY <= invelocityY;
		velocityX <= invelocityX;
	end
	
end*/

//outputs
assign outvelocityX = velocityX;
assign outvelocityY = velocityY;
assign topLeftX_position=topLeftXInt / FIXED_POINT_MULTIPLIER;
assign topLeftY_position=topLeftYInt / FIXED_POINT_MULTIPLIER;


endmodule
