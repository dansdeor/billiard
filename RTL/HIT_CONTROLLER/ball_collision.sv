module ball_collision (
					input logic clk,
					input logic resetN,
					
					input logic ballDR_1,
					input logic ballDR_2,
					
					input logic signed [10:0] ballTopLeftPosX_1,
					input logic signed [10:0] ballTopLeftPosy_1,
					input logic signed [10:0] ballVelX_1,
					input logic signed [10:0] ballVelY_1,
					
					input logic signed [10:0] ballTopLeftPosX_2,
					input logic signed [10:0] ballTopLeftPosy_2,
					input logic signed [10:0] ballVelX_2,
					input logic signed [10:0] ballVelY_2,
					
					output logic signed [10:0] ballVelXOut_1,
					output logic signed [10:0] ballVelYOut_1,
					
					output logic signed [10:0] ballVelXOut_2,
					output logic signed [10:0] ballVelYOut_2,
					
					output logic collisionOccurred
);

int unitVectorX, unitVectorY;
int tangentVectorX, tangentVectorY;
int unitVectorNormSquared;
always_ff @(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		collisionOccurred <= 1'b0;
	end
	else begin
		// Default value
		collisionOccurred <= 1'b0;
		ballVelXOut_1 <= ballVelX_1;
		ballVelYOut_1 <= ballVelY_1;
		ballVelXOut_2 <= ballVelX_2;
		ballVelYOut_2 <= ballVelY_2;
		
		if(ballDR_1 && ballDR_2) begin
			// for the collision algorithm we first nedd to set initial relative position vectors
			unitVectorX = ballTopLeftPosX_2 - ballTopLeftPosX_1;
			unitVectorY = ballTopLeftPosy_2 - ballTopLeftPosy_1;
			tangentVectorX = -unitVectorY;
			tangentVectorY = unitVectorX;
			unitVectorNormSquared = unitVectorX ^ 2 + unitVectorY ^ 2;
			// 
		end
		
	end
end

endmodule
