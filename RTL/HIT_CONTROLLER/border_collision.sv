module border_collision #(parameter TOP_OFFSET, DOWN_OFFSET, LEFT_OFFSET, RIGHT_OFFSET)
(
					input logic clk,
					input logic resetN,
					
					input logic ballDR,
					input logic bordersDR,
					
					input logic signed [10:0] ballTopLeftPosX,
					input logic signed [10:0] ballTopLeftPosY,
					input logic signed [10:0] ballVelX,
					input logic signed [10:0] ballVelY,
					
					output logic signed [10:0] ballVelXOut,
					output logic signed [10:0] ballVelYOut,
					output logic collisionOccurred
);

logic flag = 1'b1;
const int BALL_RADIUS = 32;

always_ff @(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		flag <= 1'b1;
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
		if(ballDR && bordersDR && flag) begin
			flag <= 1'b0;
			collisionOccurred <= 1'b1;
			// Now we need to check the type of the collision
			// The ball hit a vertical borders
			if(ballTopLeftPosX <= LEFT_OFFSET || ballTopLeftPosX + BALL_RADIUS >= RIGHT_OFFSET) begin
				ballVelXOut <= -ballVelX;
			end
			// The ball hit a vertical borders
			if(ballTopLeftPosY <= TOP_OFFSET || ballTopLeftPosY + BALL_RADIUS >= DOWN_OFFSET) begin
				ballVelYOut <= -ballVelY;
			end	
		end
		else if (!(ballDR && bordersDR)) begin
			flag <= 1'b1;
		end
	end
end

endmodule
