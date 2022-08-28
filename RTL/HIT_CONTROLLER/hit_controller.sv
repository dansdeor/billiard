module hit_controller (
	input logic clk,
	input logic resetN,

	input logic whiteBallDR,
	input logic redBallDR,
	input logic bordersDR,

	input logic holeDR1,
	input logic holeDR2,
	input logic holeDR3,
	input logic holeDR4,
	input logic holeDR5,
	input logic holeDR6,

	//ball position and velocity (velocities are most important for ball and border collision detection)
	input logic [10:0] whiteBallTopLeftPosX,
	input logic [10:0] whiteballTopLeftPosY,
	input logic signed [10:0] whiteBallVelX,
	input logic signed [10:0] whiteBallVelY,

	input logic [10:0] redBallTopLeftPosX,
	input logic [10:0] redBallTopLeftPosY,
	input logic signed [10:0] redBallVelX,
	input logic signed [10:0] redBallVelY,

	output logic signed [10:0] whiteBallVelXOut,
	output logic signed [10:0] whiteBallVelYOut,
	output logic whiteBallCollisionOccurred,
	output logic whiteBallHoleHit,
	output logic [2:0] whiteBallHoleNum,

	output logic signed [10:0] redBallVelXOut,
	output logic signed [10:0] redBallVelYOut,
	output logic redBallCollisionOccurred,
	output logic redBallHoleHit,
	output logic [2:0] redBallHoleNum
);

parameter int TOP_OFFSET = 0, DOWN_OFFSET = 479, LEFT_OFFSET = 0, RIGHT_OFFSET = 639;

logic signed [10:0] borderWhiteBallVelX;
logic signed [10:0] borderWhiteBallVelY;
logic signed [10:0] ballColWhiteBallVelX;
logic signed [10:0] ballColWhiteBallVelY;
logic borderWhiteBallCol;

logic signed [10:0] borderRedBallVelX;
logic signed [10:0] borderRedBallVelY;
logic signed [10:0] ballColRedBallVelX;
logic signed [10:0] ballColRedBallVelY;
logic borderRedBallCol;

logic ballToBallCol;

border_collision #(TOP_OFFSET, DOWN_OFFSET, LEFT_OFFSET, RIGHT_OFFSET) white_ball_border_col(
	.clk(clk),
	.resetN(resetN),
	.ballDR(whiteBallDR),
	.bordersDR(bordersDR),
	.ballTopLeftPosX(whiteBallTopLeftPosX),
	.ballTopLeftPosY(whiteballTopLeftPosY),
	.ballVelX(whiteBallVelX),
	.ballVelY(whiteBallVelY),
	.ballVelXOut(borderWhiteBallVelX),
	.ballVelYOut(borderWhiteBallVelY),
	.collisionOccurred(borderWhiteBallCol)
);

border_collision #(TOP_OFFSET, DOWN_OFFSET, LEFT_OFFSET, RIGHT_OFFSET) red_ball_border_col(
	.clk(clk),
	.resetN(resetN),
	.ballDR(redBallDR),
	.bordersDR(bordersDR),
	.ballTopLeftPosX(redBallTopLeftPosX),
	.ballTopLeftPosY(redBallTopLeftPosY),
	.ballVelX(redBallVelX),
	.ballVelY(redBallVelY),
	.ballVelXOut(borderRedBallVelX),
	.ballVelYOut(borderRedBallVelY),
	.collisionOccurred(borderRedBallCol)
);
/*
ball_collision (
	.clk(clk),
	.resetN(resetN),
	.ballDR1(whiteBallDR),
	.ballDR2(redBallDR),
	.ballTopLeftPosX1(whiteBallTopLeftPosX),
	.ballTopLeftPosY1(whiteballTopLeftPosY),
	.ballVelX1(whiteBallVelX),
	.ballVelY1(whiteBallVelY),
	.ballTopLeftPosX2(redBallTopLeftPosX),
	.ballTopLeftPosY2(redBallTopLeftPosY),
	.ballVelX2(redBallVelX),
	.ballVelY2(redBallVelY),
	.ballVelXOut1(ballColWhiteBallVelX),
	.ballVelYOut1(ballColWhiteBallVelY),
	.ballVelXOut2(ballColRedBallVelX),
	.ballVelYOut2(ballColRedBallVelY),
	.collisionOccurred(ballToBallCol)
);
*/

//TODO: add mux between cols of border and ball
//for now
always_comb begin
	if(borderWhiteBallCol) begin
		whiteBallVelXOut = borderWhiteBallVelX;
		whiteBallVelYOut = borderWhiteBallVelY;
	end
	/*
	else if(ballToBallCol) begin
		whiteBallVelXOut = ballColWhiteBallVelX;
		whiteBallVelYOut = ballColWhiteBallVelY;
	end
	*/
	else begin
		whiteBallVelXOut = 11'b0;
		whiteBallVelYOut = 11'b0;
	end
end

always_comb begin
	if(borderRedBallCol) begin
		redBallVelXOut = borderRedBallVelX;
		redBallVelYOut = borderRedBallVelY;
	end
	/*
	else if(ballToBallCol) begin
		redBallVelXOut = ballColRedBallVelX;
		redBallVelYOut = ballColRedBallVelY;
	end
	*/
	else begin
		redBallVelXOut = 11'b0;
		redBallVelYOut = 11'b0;
	end
end

assign whiteBallCollisionOccurred = borderWhiteBallCol | ballToBallCol;
assign redBallCollisionOccurred = borderRedBallCol | ballToBallCol;

endmodule
