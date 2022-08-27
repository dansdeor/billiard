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
	input logic holeDR1,
	input logic	[7:0] RGBHole1, 	
	input logic holeDR2,
	input logic	[7:0] RGBHole2,
	input logic holeDR3,
	input logic	[7:0] RGBHole3,
	input logic holeDR4,
	input logic	[7:0] RGBHole4,
	input logic holeDR5,
	input logic	[7:0] RGBHole5,
	input logic holeDR6,
	input logic	[7:0] RGBHole6, 

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
		else if (holeDR1 == 1'b1) begin
			RGBOut <= RGBHole1;
		end
		else if (holeDR2 == 1'b1) begin
			RGBOut <= RGBHole2;
		end
		else if (holeDR3 == 1'b1) begin
			RGBOut <= RGBHole3;
		end
		else if (holeDR4 == 1'b1) begin
			RGBOut <= RGBHole4;
		end
		else if (holeDR5 == 1'b1) begin
			RGBOut <= RGBHole5;
		end
		else if (holeDR6 == 1'b1) begin
			RGBOut <= RGBHole6;
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
