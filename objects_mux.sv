module objects_mux (
	input logic	clk,
	input logic	resetN,
	// balls layout
	input logic whiteBallDR,
	input logic	[7:0] RGBWhiteBall,
	input logic redBallDR,
	input logic	[7:0] RGBRedBall,
	// hole number to hit
	input logic holeNumberDR,
	input logic	[7:0] RGBHoleNumber,
	// holes layout
	input logic holesDR,
	input logic	[7:0] RGBHoles,
	// borders layout
	input logic bordersDR,
	input logic	[7:0] RGBBorders,
	// board layout
	input logic boardDR,
	input logic	[7:0] RGBBoard, 

	output logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBOut <= 8'b0;
	end
	
	else begin
		if (whiteBallDR == 1'b1) begin
			RGBOut <= RGBWhiteBall;
		end
		else if (redBallDR == 1'b1) begin
			RGBOut <= RGBRedBall;
		end
		else if (holeNumberDR == 1'b1) begin
			RGBOut <= RGBHoleNumber;
		end
		else if (holesDR == 1'b1) begin
			RGBOut <= RGBHoles;
		end
		else if (bordersDR == 1'b1) begin
			RGBOut <= RGBBorders;
		end
		else if (boardDR == 1'b1) begin
			RGBOut <= RGBBoard;
		end
		else begin
			RGBOut <= 8'b0;
		end
	end
end

endmodule
