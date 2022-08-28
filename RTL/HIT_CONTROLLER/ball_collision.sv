module ball_collision (
	input logic clk,
	input logic resetN,

	input logic ballDR1,
	input logic ballDR2,

	input logic [10:0] ballTopLeftPosX1,
	input logic [10:0] ballTopLeftPosY1,
	input logic signed [10:0] ballVelX1,
	input logic signed [10:0] ballVelY1,

	input logic [10:0] ballTopLeftPosX2,
	input logic [10:0] ballTopLeftPosY2,
	input logic signed [10:0] ballVelX2,
	input logic signed [10:0] ballVelY2,

	output logic signed [10:0] ballVelXOut1,
	output logic signed [10:0] ballVelYOut1,

	output logic signed [10:0] ballVelXOut2,
	output logic signed [10:0] ballVelYOut2,

	output logic collisionOccurred
);


logic flag = 1'b1;
const int BALL_RADIUS = 32;

int normalVectorNormSquared;
int normalVectorX, normalVectorY;
int tangentVectorX, tangentVectorY;
int tangentX1, tangentX2, tangentY1, tangentY2;
int normalX1, normalX2, normalY1, normalY2;

// For the collision algorithm we first nedd to set initial relative position vectors
assign normalVectorX = ballTopLeftPosX2 - ballTopLeftPosX1;
assign normalVectorY = ballTopLeftPosY2 - ballTopLeftPosY1;

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
			collisionOccurred <= 1'b1;
			normalVectorNormSquared = normalVectorX ** 2 + normalVectorY ** 2;
			if(normalVectorNormSquared) begin
				tangentVectorX = -normalVectorY;
				tangentVectorY = normalVectorX;
				// Now we need to set new vector velocities
				normalX1 = normalVectorX * (normalVectorX * ballVelX2 + normalVectorY * ballVelY2);
				normalY1 = normalVectorY * (normalVectorX * ballVelX2 + normalVectorY * ballVelY2);
				tangentX1 = tangentVectorX * (tangentVectorX * ballVelX1 + tangentVectorY * ballVelY1);
				tangentY1 = tangentVectorY * (tangentVectorX * ballVelX1 + tangentVectorY * ballVelY1);
				// We do the same calculation for the other ball
				normalX2 = normalVectorX * (normalVectorX * ballVelX1 + normalVectorY * ballVelY1);
				normalY2 = normalVectorY * (normalVectorX * ballVelX1 + normalVectorY * ballVelY1);
				tangentX2 = tangentVectorX * (tangentVectorX * ballVelX2 + tangentVectorY * ballVelY2);
				tangentY2 = tangentVectorY * (tangentVectorX * ballVelX2 + tangentVectorY * ballVelY2);
				// And for the moment of truth we add the normal vector and the tangent to get the velocity after the collision
				ballVelXOut1 <= (normalX1 + tangentX1) / normalVectorNormSquared;
				ballVelYOut1 <= (normalY1 + tangentY1) / normalVectorNormSquared;
				ballVelXOut2 <= (normalX2 + tangentX2) / normalVectorNormSquared;
				ballVelYOut2 <= (normalY2 + tangentY2) / normalVectorNormSquared;
			end
		end
		// Using the ballDR1 and ballDR2 for knowing the time to enable the flag is not enough because the balls are round and we can get a cenario
		// where sometimes the DRs are "1" and sometimes the DRs are "0" in the same frame we are drawing
		else if((normalVectorX >= BALL_RADIUS || normalVectorX <= -BALL_RADIUS) && (normalVectorY >= BALL_RADIUS || normalVectorY <= -BALL_RADIUS)) begin
			flag <= 1'b1;
		end
	end
end

endmodule
