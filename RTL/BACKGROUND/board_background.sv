module board_background (
					input logic clk,
					input logic [10:0] pixelX,
					input logic [10:0] pixelY,

					output logic drawingRequestBoard,
					output logic [7:0] RGBoutBoard
);

// Screen resolution -> 640 cols 480 rows

parameter int TOP_OFFSET = 0, DOWN_OFFSET = 479, LEFT_OFFSET = 0, RIGHT_OFFSET = 639;
localparam logic [7:0] boardColor = 8'b00010100;

assign RGBoutBoard = boardColor;

always_ff @(posedge clk)
begin
	
	if((pixelX >= LEFT_OFFSET) && (pixelX <= RIGHT_OFFSET) && (pixelY >= TOP_OFFSET) && (pixelY <= DOWN_OFFSET)) begin
		drawingRequestBoard <= 1'b1;
	end
	
	else begin
		drawingRequestBoard <= 1'b0;
	end

end

endmodule
