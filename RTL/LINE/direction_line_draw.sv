module direction_line_draw(	
	input logic clk,
	
	input logic signed [10:0] pixelX,
	input logic signed [10:0] pixelY,
	
	input logic signed [10:0] lineTopLeftPosX,
	input logic signed [10:0] lineTopLeftPosY,
	
	input logic signed [10:0] velocityX,
	input logic signed [10:0] velocityY,
	
	output logic drawingRequestLine,
	output logic [7:0] RGBoutLine
);

const int BALL_RADIUS = 16;
const int LINE_THICKNESS = 80;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hff;

int yDiffer, xDiffer, rightSide, middleSide, leftSide;

logic signed [10:0] innerlineTopLeftPosX;
logic signed [10:0] innerlineTopLeftPosY;
logic signed [10:0] innervelocityX;
logic signed [10:0] innervelocityY;

always_ff @(posedge clk) begin	

//defaults
	RGBoutLine <= TRANSPARENT_ENCODING;
	
	// For getting the right entry point of the line
	innerlineTopLeftPosX <= lineTopLeftPosX + BALL_RADIUS;
	innerlineTopLeftPosY <= lineTopLeftPosY + BALL_RADIUS;
	// For getting the right final point of the line
	innervelocityX <= velocityX + lineTopLeftPosX + BALL_RADIUS;
	innervelocityY <= velocityY + lineTopLeftPosY + BALL_RADIUS;
	
	//Line Drawing condition
	yDiffer <= innervelocityY - innerlineTopLeftPosY;
	xDiffer <= innervelocityX - innerlineTopLeftPosX;
	rightSide <= (yDiffer*(pixelX - innerlineTopLeftPosX) + LINE_THICKNESS);
	middleSide <= xDiffer* (pixelY -innerlineTopLeftPosY);
	leftSide <=  (yDiffer*(pixelX - innerlineTopLeftPosX) - LINE_THICKNESS);
	
	if( (middleSide >= leftSide) && (middleSide <= rightSide)) begin
		if (((pixelX >= innerlineTopLeftPosX) && (pixelX <= innervelocityX) )|| (pixelX <= innerlineTopLeftPosX) && (pixelX >= innervelocityX)) begin
			if (((pixelY >= innerlineTopLeftPosY) && (pixelY <= innervelocityY) )|| (pixelY <= innerlineTopLeftPosY) && (pixelY >= innervelocityY)) begin
				RGBoutLine <= 8'b00000011;
			end
		end
	end
end

assign drawingRequestLine = (RGBoutLine != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0;

endmodule
