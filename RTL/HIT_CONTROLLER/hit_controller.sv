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
	input logic signed [10:0] whiteBallTopLeftPosX,
	input logic signed [10:0] whiteballTopLeftPosY,
	input logic signed [10:0] whiteBallVelX,
	input logic signed [10:0] whiteBallVelY,

	input logic signed [10:0] redBallTopLeftPosX,
	input logic signed [10:0] redballTopLeftPosY,
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
logic borderWhiteBallCol;

logic signed [10:0] borderRedBallVelX;
logic signed [10:0] borderRedBallVelY;
logic borderRedBallCol;

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
	.ballTopLeftPosY(redballTopLeftPosY),
	.ballVelX(redBallVelX),
	.ballVelY(redBallVelY),
	.ballVelXOut(borderRedBallVelX),
	.ballVelYOut(borderRedBallVelY),
	.collisionOccurred(borderRedBallCol)
);

//TODO: add mux between cols of border and ball
//for now
always_comb begin
	if(borderWhiteBallCol) begin
		whiteBallVelXOut = borderWhiteBallVelX;
		whiteBallVelYOut = borderWhiteBallVelY;
	end
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
	else begin
		redBallVelXOut = 11'b0;
		redBallVelYOut = 11'b0;
	end
end

// TODO: add OR with ball collision
assign whiteBallCollisionOccurred = borderWhiteBallCol;
assign redBallCollisionOccurred = borderRedBallCol;

endmodule
