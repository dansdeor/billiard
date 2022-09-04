module objects_mux (
	// Game statistics
	input logic statDR,
	input logic	[7:0] RGBStat,
	// Line layout
	input logic lineDR,
	input logic	[7:0] RGBLine,
	// Balls layout
	input logic whiteBallDR,
	input logic	[7:0] RGBWhiteBall,
	input logic redBallDR,
	input logic	[7:0] RGBRedBall,
	// Hole number to hit
	input logic holeNumberDR,
	input logic	[7:0] RGBHoleNumber,
	// Holes layout
	input logic holesDR,
	input logic	[7:0] RGBHoles,
	// Borders layout
	input logic bordersDR,
	input logic	[7:0] RGBBorders,
	// Board layout
	input logic boardDR,
	input logic	[7:0] RGBBoard, 
	
	output logic [7:0] RGBOut
);

always_comb begin
	if (statDR == 1'b1) begin
		RGBOut = RGBStat;
	end
	else if (lineDR == 1'b1) begin
		RGBOut = RGBLine;
	end
	else if (whiteBallDR == 1'b1) begin
		RGBOut = RGBWhiteBall;
	end
	else if (redBallDR == 1'b1) begin
		RGBOut = RGBRedBall;
	end
	else if (holeNumberDR == 1'b1) begin
		RGBOut = RGBHoleNumber;
	end
	else if (holesDR == 1'b1) begin
		RGBOut = RGBHoles;
	end
	else if (bordersDR == 1'b1) begin
		RGBOut = RGBBorders;
	end
	else if (boardDR == 1'b1) begin
		RGBOut = RGBBoard;
	end
	else begin
		RGBOut = 8'b0;
	end
end

endmodule
