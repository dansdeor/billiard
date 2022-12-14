module border_collision #(parameter TOP_OFFSET, DOWN_OFFSET, LEFT_OFFSET, RIGHT_OFFSET)
(
	input logic clk,
	input logic resetN,
	
	input logic ballDR,
	input logic bordersDR,
	
	input logic [10:0] ballTopLeftPosX,
	input logic [10:0] ballTopLeftPosY,
	input logic signed [10:0] ballVelX,
	input logic signed [10:0] ballVelY,
	
	output logic signed [10:0] ballVelXOut,
	output logic signed [10:0] ballVelYOut,
	output logic collisionOccurred
);

const int BALL_DIAMETER = 32;

always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		ballVelXOut <= 11'b0;
		ballVelXOut <= 11'b0;
	end
	else begin
		// Default value
		collisionOccurred <= 1'b0;
		ballVelXOut <= ballVelX;
		ballVelYOut <= ballVelY;

		// Collision occurres only when the DR of both objects is 1
		// We dont want to change the velocities all the time when the drawing requests are on
		// only once.
		if(ballDR && bordersDR) begin
			collisionOccurred <= 1'b1;
			// Now we need to check the type of the collision
			// The ball hit a vertical borders
			if(ballTopLeftPosX <= LEFT_OFFSET && ballVelX < 0) begin
				ballVelXOut <= -ballVelX;
			end
			else if(ballTopLeftPosX + BALL_DIAMETER >= RIGHT_OFFSET && ballVelX > 0) begin
				ballVelXOut <= -ballVelX;
			end
			// The ball hit a vertical borders
			if(ballTopLeftPosY <= TOP_OFFSET && ballVelY < 0) begin
				ballVelYOut <= -ballVelY;
			end
			else if(ballTopLeftPosY + BALL_DIAMETER >= DOWN_OFFSET && ballVelY > 0) begin
				ballVelYOut <= -ballVelY;
			end
		end
	end
end

endmodule
