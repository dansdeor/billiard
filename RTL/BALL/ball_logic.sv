module ball_logic #(parameter INITIAL_POSITION_X, INITIAL_POSITION_Y)
(
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

const int INITIAL_VELOCITY_X = 0;
const int INITIAL_VELOCITY_Y = 0;

const int FRICTION_FRAME_COUNT = 5;
const int VELOCITY_FRICTION = 1;
const int VELOCITY_LIMIT = 200;
int frictionCounterY = 0;
int frictionCounterX = 0;

int velocityX, topLeftXInt;
int velocityY, topLeftYInt;

const int FIXED_POINT_MULTIPLIER = 64;// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution 

// Y_direction_moves
always_ff @(posedge clk or negedge resetN) begin	
	if(!resetN) begin 
		velocityY <= INITIAL_VELOCITY_Y;
		topLeftYInt	<= INITIAL_POSITION_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if(velocityWriteEnable) begin
			velocityY <= inVelocityY;
		end
		// Perform position and velocity addition only when a new frame starts
		else if (startOfFrame) begin
			frictionCounterY = frictionCounterY + 1;
			topLeftYInt <= topLeftYInt + velocityY;// POSITION interpolation 
			if ( frictionCounterY % FRICTION_FRAME_COUNT == 0) begin
				if (velocityY > 0) begin
					velocityY <= velocityY - VELOCITY_FRICTION;
					if(velocityY < 0)
						velocityY <= 0;
				end		
				else if (velocityY < 0) begin
					velocityY <= velocityY + VELOCITY_FRICTION;
					if(velocityY > 0)
						velocityY <= 0;
				end
			end
			
		end
		// Velocity limiting
		if(velocityY > VELOCITY_LIMIT) begin
			velocityY <= VELOCITY_LIMIT;
		end
		if(velocityY < -VELOCITY_LIMIT) begin
			velocityY <= -VELOCITY_LIMIT;
		end
	end
end

// X_direction_moves
always_ff @(posedge clk or negedge resetN) begin	
	if(!resetN) begin 
		velocityX	<= INITIAL_VELOCITY_X;
		topLeftXInt	<= INITIAL_POSITION_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
		// For collision, the collision velocity we get from our cotroller
		if(velocityWriteEnable) begin
			velocityX <= inVelocityX;
		end
		// Perform position and velocity addition only when a new frame starts
		else if (startOfFrame) begin
			frictionCounterX <= frictionCounterX + 1;
			topLeftXInt <= topLeftXInt + velocityX;
			if ( frictionCounterX % FRICTION_FRAME_COUNT == 0) begin
				if (velocityX > 0) begin
					velocityX <= velocityX - VELOCITY_FRICTION;
					if(velocityX < 0)
						velocityX <= 0;
				end
				else if (velocityX < 0) begin
					velocityX <= velocityX + VELOCITY_FRICTION;
					if(velocityX > 0)
						velocityX <= 0;
				end
			end
		end
		// Velocity limiting
		if(velocityX > VELOCITY_LIMIT) begin
			velocityX <= VELOCITY_LIMIT;
		end
		if(velocityX < -VELOCITY_LIMIT) begin
			velocityX <= -VELOCITY_LIMIT;
		end
	end
end 

//outputs
assign outVelocityX = velocityX;
assign outVelocityY = velocityY;
assign topLeftPosX = topLeftXInt / FIXED_POINT_MULTIPLIER;
assign topLeftPosY = topLeftYInt / FIXED_POINT_MULTIPLIER;
assign ballStopped = outVelocityX == 11'b0 && outVelocityY == 11'b0;

endmodule
