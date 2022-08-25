module borders (
					input logic clk,
					input logic signed [10:0] pixelX,
					input logic signed [10:0] pixelY,

					output logic drawingRequestBorders,
					output logic [7:0] RGBoutBorders
);

parameter int TOP_OFFSET = 0, DOWN_OFFSET = 0, LEFT_OFFSET = 0, RIGHT_OFFSET = 0;
localparam logic [7:0] borderColor = 8'b10101100;

assign RGBoutBorders = borderColor;

always_ff @(posedge clk)
begin
	
	if((pixelX < LEFT_OFFSET) || (pixelX > RIGHT_OFFSET) || (pixelY < TOP_OFFSET) || (pixelY > DOWN_OFFSET)) begin
		drawingRequestBorders <= 1'b1;
	end
	
	else begin
		drawingRequestBorders <= 1'b0;
	end

end

endmodule
