module borders (
					input logic clk,
					//input logic resetN,
					input logic signed [10:0] pixelX,
					input logic signed [10:0] pixelY,

					output logic drawingRequestBorders,
					output logic [7:0] RGBoutBorders
);

// Screen resolution -> 640 cols 480 rows

const int TOP_OFFSET = 40;
const int DOWN_OFFSET = 440; 
const int RIGHT_OFFSET = 600;
const int LEFT_OFFSET = 30;

localparam logic [7:0] borderColor = 8'b10101100;
assign RGBoutBorders = borderColor;

always_ff@(posedge clk)// or negedge resetN)
begin
	
	if((pixelX < LEFT_OFFSET) || (pixelX > RIGHT_OFFSET) || (pixelY < TOP_OFFSET) || (pixelY > DOWN_OFFSET)) begin
		drawingRequestBorders <= 1'b1;
	end
	
	else begin
		drawingRequestBorders <= 1'b0;
	end

end

endmodule
