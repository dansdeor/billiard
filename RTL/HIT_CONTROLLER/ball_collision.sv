module ball_collision (
					input logic clk,
					input logic resetN,
					
					input logic ballDR1,
					input logic ballDR2,
					
					input logic signed [10:0] ballTopLeftPosX1,
					input logic signed [10:0] ballTopLeftPosY1,
					input logic signed [10:0] ballVelX1,
					input logic signed [10:0] ballVelY1,
					
					input logic signed [10:0] ballTopLeftPosX2,
					input logic signed [10:0] ballTopLeftPosY2,
					input logic signed [10:0] ballVelX2,
					input logic signed [10:0] ballVelY2,
					
					output logic signed [10:0] ballVelXOut1,
					output logic signed [10:0] ballVelYOut1,
					
					output logic signed [10:0] ballVelXOut2,
					output logic signed [10:0] ballVelYOut2,
					
					output logic collisionOccurred
);


logic flag = 1'b1;

int unitVectorNormSquared;
int unitVectorX, unitVectorY;
int tangentVectorX, tangentVectorY;
int tangentX1, tangentX2, tangentY1, tangentY2;
int unitX1, unitX2, unitY1, unitY2;

always_ff @(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		flag <= 1'b1;
		collisionOccurred <= 1'b0;
		ballVelXOut1 <= 11'b0;
		ballVelYOut1 <= 11'b0;
		ballVelXOut2 <= 11'b0;
		ballVelYOut2 <= 11'b0;
	end
	else begin
		// Default value
		collisionOccurred <= 1'b0;
		ballVelXOut1 <= ballVelX1;
		ballVelYOut1 <= ballVelY1;
		ballVelXOut2 <= ballVelX2;
		ballVelYOut2 <= ballVelY2;
		
		if(ballDR1 && ballDR2 && flag) begin
			flag <= 1'b0;
			// For the collision algorithm we first nedd to set initial relative position vectors
			unitVectorX = ballTopLeftPosX2 - ballTopLeftPosX1;
			unitVectorY = ballTopLeftPosY2 - ballTopLeftPosY1;
			unitVectorNormSquared = unitVectorX ** 2 + unitVectorY ** 2;
			if(unitVectorNormSquared) begin
				tangentVectorX = -unitVectorY;
				tangentVectorY = unitVectorX;
				// Now we need to set new vector velocities
				unitX1 = unitVectorX * (unitVectorX * ballVelX2 + unitVectorY * ballVelY2);
				unitY1 = unitVectorY * (unitVectorX * ballVelX2 + unitVectorY * ballVelY2);
				tangentX1 = tangentVectorX * (tangentVectorX * ballVelX1 + tangentVectorY * ballVelY1);
				tangentY1 = tangentVectorY * (tangentVectorX * ballVelX1 + tangentVectorY * ballVelY1);
				// We do the same calculation for the other ball
				unitX2 = unitVectorX * (unitVectorX * ballVelX1 + unitVectorY * ballVelY1);
				unitY2 = unitVectorY * (unitVectorX * ballVelX1 + unitVectorY * ballVelY1);
				tangentX2 = tangentVectorX * (tangentVectorX * ballVelX2 + tangentVectorY * ballVelY2);
				tangentY2 = tangentVectorY * (tangentVectorX * ballVelX2 + tangentVectorY * ballVelY2);
				// And for the moment of truth we add the unit vector and the tangent to get the velocity after the collision
				ballVelXOut1 <= (unitX1 + tangentX1) / unitVectorNormSquared;
				ballVelYOut1 <= (unitY1 + tangentY1) / unitVectorNormSquared;
				ballVelXOut2 <= (unitX2 + tangentX2) / unitVectorNormSquared;
				ballVelYOut2 <= (unitY2 + tangentY2) / unitVectorNormSquared;
			end
		end
		
		else if (!(ballDR1 && ballDR2)) begin
			flag <= 1'b1;
		end
		
	end
end

endmodule
