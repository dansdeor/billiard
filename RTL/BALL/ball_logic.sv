module ball_logic (
					input logic clk,
					input logic resetN,
					input logic startOfFrame,
					
					input logic velocityWriteEnable,
					input logic signed [10:0] inVelocityX,
					input logic signed [10:0] inVelocityY,
					
					output logic [10:0] topLeftPosX,
					output logic [10:0] topLeftPosY,
					
					output logic signed [10:0] outVelocityX,
					output logic signed [10:0] outVelocityY,
					output logic ballStopped
);

parameter int INITIAL_Y_VELOCITY = 0;
parameter int INITIAL_X_VELOCITY = 0;
parameter int INITIAL_Y_POSITION = 0;
parameter int INITIAL_X_POSITION = 0;

const int FRICTION_FRAME_COUNT = 10;
const int VELOCITY_Y_FRICTION = 1;
const int VELOCITY_X_FRICTION = 1;
int frictionCounterY = 0;
int frictionCounterX = 0;

int velocityX, topLeftXInt;
int velocityY, topLeftYInt;

const int FIXED_POINT_MULTIPLIER = 64;// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution 

// Y_direction_moves
always_ff @(posedge clk or negedge resetN)
begin	
	if(!resetN) begin 
		velocityY <= INITIAL_Y_VELOCITY;
		topLeftYInt	<= INITIAL_Y_POSITION * FIXED_POINT_MULTIPLIER;
	end
	//for collision, the collision velocity we get from our cotroller
	else if(velocityWriteEnable) begin
		velocityY <= inVelocityY;
	end
	// perform  POSITION and velocity integral only when a new frame starts
	else if (startOfFrame) begin
		frictionCounterY = frictionCounterY + 1;
		topLeftYInt <= topLeftYInt + velocityY;// POSITION interpolation 
		//TODO : MAKE SURE THAT THE BALL ISN'T ON THE EDGES AFTER THE CHANGE!!!
		if ( frictionCounterY % FRICTION_FRAME_COUNT == 0) begin
			if (velocityY > 0) begin
				velocityY <= velocityY - VELOCITY_Y_FRICTION;
				if(velocityY < 0)
					velocityY <= 0;
			end		
			else if (velocityY < 0) begin
				velocityY <= velocityY + VELOCITY_Y_FRICTION;
				if(velocityY > 0)
					velocityY <= 0;
			end
		end
	end
end

// X_direction_moves
always_ff @(posedge clk or negedge resetN)
begin	
	if(!resetN) begin 
		velocityX	<= INITIAL_X_VELOCITY;
		topLeftXInt	<= INITIAL_X_POSITION * FIXED_POINT_MULTIPLIER;
	end
	//for collision, the collision velocity we get from our cotroller
	else if(velocityWriteEnable) begin
		velocityX <= inVelocityX;
	end
	// perform  POSITION and velocity integral only when a new frame starts
	else if (startOfFrame) begin
		frictionCounterX <= frictionCounterX + 1;
		topLeftXInt <= topLeftXInt + velocityX;	// POSITION interpolation 
		//TODO : MAKE SURE THAT THE BALL ISN'T ON THE EDGES AFTER THE CHANGE!!!
		if ( frictionCounterX % FRICTION_FRAME_COUNT == 0) begin
			if (velocityX > 0) begin
				velocityX <= velocityX - VELOCITY_X_FRICTION;
				if(velocityX < 0)
					velocityX <= 0;
			end
			else if (velocityX < 0) begin
				velocityX <= velocityX + VELOCITY_X_FRICTION;
				if(velocityX > 0)
					velocityX <= 0;
			end
		end
	end
end 

//outputs
assign outVelocityX = velocityX;
assign outVelocityY = velocityY;
assign topLeftPosX = topLeftXInt / FIXED_POINT_MULTIPLIER;
assign topLeftPosY = topLeftYInt / FIXED_POINT_MULTIPLIER;
assign ballStopped = ~(outVelocityX & outVelocityY);

endmodule
