module ball_draw (
	input logic clk,
	input logic signed [10:0] pixelX,
	input logic signed [10:0] pixelY,
	input logic signed [10:0] ballTopLeftPosX,
	input logic signed [10:0] ballTopLeftPosY,

	output logic drawingRequestBall,
	output logic [7:0] RGBoutBall
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hff;
const int BITMAP_WIDTH = 32;
const int BITMAP_HEIGHT = 32;

// 0 for white 1 for red index
parameter logic BALL_COLOR = 0;

 
logic [1:0][0:31][0:31][7:0] ballBitmap = {
	// Red ball bitmap
	{{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff},
	{8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff},
	{8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff},
	{8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff},
	{8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0},
	{8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'h49},
	{8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff},
	{8'hff,8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff},
	{8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hc0,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}},
	// White ball bitmap
	{{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff},
	{8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff},
	{8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff},
	{8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff},
	{8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe},
	{8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h49},
	{8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff},
	{8'hff,8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff},
	{8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h49,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}}};
	
always_ff@(posedge clk) 
begin 
	RGBoutBall <= TRANSPARENT_ENCODING; 
	if ((ballTopLeftPosX <= pixelX) && (ballTopLeftPosX + BITMAP_WIDTH > pixelX) && (ballTopLeftPosY + BITMAP_HEIGHT > pixelY) && (ballTopLeftPosY <= pixelY)) begin 
		RGBoutBall <= ballBitmap[BALL_COLOR][pixelY - ballTopLeftPosY][pixelX - ballTopLeftPosX];
	end
end 

assign drawingRequestBall = (RGBoutBall != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0;
endmodule
