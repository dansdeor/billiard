module border_collision #(parameter TOP_OFFSET, DOWN_OFFSET, RIGHT_OFFSET, LEFT_OFFSET)
(
					input logic clk,
					input logic resetN,
					
					input logic ballDR,
					input logic borderDR,
					
					input logic signed [10:0] ballTopLeftPosX,
					input logic signed [10:0] ballTopLeftPosy,
					input logic signed [10:0] ballVelX,
					input logic signed [10:0] ballVelY,
					
					output logic collisionOccurred,
					output logic signed [10:0] ballVelXOut,
					output logic signed [10:0] ballVelYOut
);

always_ff @(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		ballVelXOut <= 11'b0;
		ballVelXOut <= 11'b0;
	end
	else begin
		// Default value
		collisionOccurred <= 1'b0;
		ballVelXOut <= ballVelX;
		ballVelYOut <= ballVelY;
		
		// Collision occurred only when the DR of both objects is 1
		if(ballDR && borderDR) begin
			collisionOccurred <= 1'b1;
			
			// Now we need to check the type of the collision
			// The ball hit a vertical borders
			if(ballTopLeftPosX <= LEFT_OFFSET || ballTopLeftPosX >= RIGHT_OFFSET) begin
				ballVelXOut <= -ballVelX;
			end
			
			// The ball hit a vertical borders
			if(ballTopLeftPosy <= TOP_OFFSET || ballTopLeftPosy >= DOWN_OFFSET) begin
				ballVelYOut <= -ballVelY;
			end
		end
	end
end

endmodule
