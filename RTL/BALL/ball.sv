module ball(
	input logic clk,
	input logic resetN,
	input logic startOfFrame,
	
	input logic [10:0] pixelX,
	input logic [10:0] pixelY,
	input logic ballShow,
	
	input logic velocityWriteEnable,
	input logic signed [10:0] inVelocityX,
	input logic signed [10:0] inVelocityY,

	output logic drawingRequestBall,
	output logic [7:0] RGBoutBall,

	output logic signed [10:0] outVelocityX,
	output logic signed [10:0] outVelocityY,
	output logic [10:0] topLeftPosX,
	output logic [10:0] topLeftPosY,
	
	output logic ballStopped

);

// 0 for white 1 for red index
parameter logic BALL_COLOR = 0;

parameter int INITIAL_POSITION_X = 0;
parameter int INITIAL_POSITION_Y = 0;

ball_logic #(INITIAL_POSITION_X, INITIAL_POSITION_Y)(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.velocityWriteEnable(velocityWriteEnable),
	.inVelocityX(inVelocityX),
	.inVelocityY(inVelocityY),
	.topLeftPosX(topLeftPosX),
	.topLeftPosY(topLeftPosY),
	.outVelocityX(outVelocityX),
	.outVelocityY(outVelocityY),
	.ballStopped(ballStopped)
);

ball_draw #(BALL_COLOR)(
	.clk(clk),
	.ballShow(ballShow),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftPosX(topLeftPosX),
	.topLeftPosY(topLeftPosY),
	.drawingRequestBall(drawingRequestBall),
	.RGBoutBall(RGBoutBall)
);

endmodule
