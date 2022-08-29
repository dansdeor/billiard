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

logic flag = 1'b1;
const int BALL_RADIUS = 32;

always_ff @(posedge clk or negedge resetN) begin
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
			if(ballTopLeftPosX <= LEFT_OFFSET && ballVelX < 0) begin
				ballVelXOut <= -ballVelX;
			end
			else if(ballTopLeftPosX + BALL_RADIUS >= RIGHT_OFFSET && ballVelX > 0) begin
				ballVelXOut <= -ballVelX;
			end
			// The ball hit a vertical borders
			if(ballTopLeftPosY <= TOP_OFFSET && ballVelY < 0) begin
				ballVelYOut <= -ballVelY;
			end
			else if(ballTopLeftPosY + BALL_RADIUS >= DOWN_OFFSET && ballVelY > 0) begin
				ballVelYOut <= -ballVelY;
			end	
		end
		if(!(ballDR && bordersDR)) begin //((ballTopLeftPosX > LEFT_OFFSET || ballTopLeftPosX + BALL_RADIUS < RIGHT_OFFSET) && (ballTopLeftPosY > TOP_OFFSET || ballTopLeftPosY + BALL_RADIUS < DOWN_OFFSET))) begin
			flag <= 1'b1;
		end
	end
end

endmodule
