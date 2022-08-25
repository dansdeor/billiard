module hit_controller (
					input logic clk,
					input logic resetN,
					
					input logic whiteBallDR,
					input logic redBallDR,
					input logic borderDR,
				
					input logic hole1DR,
					input logic hole2DR,
					input logic hole3DR,
					input logic hole4DR,
					input logic hole5DR,
					input logic hole6DR,
					
					//ball position and velocity (velocities are most important for ball and border collision detection)
					input logic signed [10:0] whiteBallTopLeftPosX,
					input logic signed [10:0] whiteBallTopLeftPosy,
					input logic signed [10:0] whiteBallVelX,
					input logic signed [10:0] whiteBallVelY,
					
					input logic signed [10:0] redBallTopLeftPosX,
					input logic signed [10:0] redBallTopLeftPosy,
					input logic signed [10:0] redBallVelX,
					input logic signed [10:0] redBallVelY,
					
					output logic signed [10:0] whiteBallVelXOut,
					output logic signed [10:0] whiteBallVelYOut,
					output logic whiteBallCollisionOccurred,
					
					output logic signed [10:0] redBallVelXOut,
					output logic signed [10:0] redBallVelYOut,
					output logic redBallCollisionOccurred
);

logic borderWhiteBallCol;
logic signed [10:0] borderWhiteBallVelX;
logic signed [10:0] borderWhiteBallVelY;

logic borderRedBallCol;
logic signed [10:0] borderRedBallVelX;
logic signed [10:0] borderRedBallVelY;

border_collision white_ball_border_col(
	.clk(clk),
	.resetN(resetN),
	.ballDR(ballDR),
	.borderDR(borderDR),
	.ballTopLeftPosX(ballTopLeftPosX),
	.ballTopLeftPosy(ballTopLeftPosy),
	.ballVelX(ballVelX),
	.ballVelY(ballVelY),
	.collisionOccurred(borderWhiteBallCol),
	.ballVelXOut(borderWhiteBallVelX),
	.ballVelYOut(borderWhiteBallVelY)
);

//TODO: add mux between cols
//for now
always_comb begin
	if(borderWhiteBallCol) begin
		whiteBallVelXOut = borderWhiteBallVelX;
		whiteBallVelXOut = borderWhiteBallVelY;
	end
	else begin
		whiteBallVelXOut = 11'b0;
		whiteBallVelXOut = 11'b0;
	end
end

assign whiteBallCollisionOccurred = borderWhiteBallCol;

endmodule
