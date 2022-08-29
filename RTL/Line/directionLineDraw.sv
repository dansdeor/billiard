module directionLineDraw (	
	input logic clk,
	
	input logic signed [10:0] pixelX,
	input logic signed [10:0] pixelY,
	
	//JUST FOR SIMPLE CHECK
	input logic signed [10:0] LineTopLeftPosX1,
	input logic signed [10:0] LineTopLeftPosY1,
	
	//input logic signed [10:0] LineTopLeftPosX2,
	//input logic signed [10:0] LineTopLeftPosY2,
	
	input logic keyEnterIsPressed,
	
	output logic drawingRequestLine,
	output logic [7:0] RGBoutLine
	);
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hff;
parameter int LINE_THICKNESS = 20;
int yDiffer, xDiffer, rightSide, middleSide, leftSide;
logic signed [10:0] ballWidth = 11'd16;
logic signed [10:0] ballHigh = 11'd16;
logic signed [10:0] innerLineTopLeftPosX1;
logic signed [10:0] innerLineTopLeftPosY1;
logic signed [10:0] innerLineTopLeftPosX2;
logic signed [10:0] innerLineTopLeftPosY2;
const int FIXED_POINT_MULTIPLIER = 64;
//parameter int LineTopLeftPosX1=0;
//parameter int LineTopLeftPosY1=0;
parameter int LineTopLeftPosX2=0;
parameter int LineTopLeftPosY2=0;


always_ff @(posedge clk)// or negedge resetN)
begin	
	//if(!resetN) begin
	
	//end
//defaults
	RGBoutLine <= TRANSPARENT_ENCODING;
	innerLineTopLeftPosX1 <= (LineTopLeftPosX1 + ballWidth); //* FIXED_POINT_MULTIPLIER;
	innerLineTopLeftPosY1 <= (LineTopLeftPosY1 + ballHigh); //* FIXED_POINT_MULTIPLIER;
	//innerLineTopLeftPosX2 <= LineTopLeftPosX2; //* FIXED_POINT_MULTIPLIER;
	//innerLineTopLeftPosY2 <= LineTopLeftPosY2; //* FIXED_POINT_MULTIPLIER;
	
	//innerKeyEnterIsPressed <= keyEnterIsPressed;

	
//Line Drawing condition
//TODO - erasing the Line by keyEnterIsPressed
	/*if(keyEnterIsPressed) begin
	LineTopLeftPosX2 <= LineTopLeftPosX1;
	LineTopLeftPosY2 <= LineTopLeftPosY2;
	*/
	
	//TODO - adding an input DrawLineEnable from the game controller
	//if(DrawLineEnable) begin
		yDiffer <= LineTopLeftPosY2 - innerLineTopLeftPosY1;
		xDiffer <= LineTopLeftPosX2 - innerLineTopLeftPosX1;
		rightSide <= (yDiffer*(pixelX - innerLineTopLeftPosX1) + LINE_THICKNESS); // FIXED_POINT_MULTIPLIER ;
		middleSide <= xDiffer* (pixelY -innerLineTopLeftPosY1);
		leftSide <=  (yDiffer*(pixelX - innerLineTopLeftPosX1) - LINE_THICKNESS); // FIXED_POINT_MULTIPLIER;
		
		if( (middleSide >= leftSide) && (middleSide <= rightSide)) begin
			if (((pixelX >= innerLineTopLeftPosX1) && (pixelX <= LineTopLeftPosX2) )|| (pixelX <= innerLineTopLeftPosX1) && (pixelX >= LineTopLeftPosX2))
				if (((pixelY >= innerLineTopLeftPosY1) && (pixelY <= LineTopLeftPosY2) )|| (pixelY <= innerLineTopLeftPosY1) && (pixelY >= LineTopLeftPosY2))
					RGBoutLine <= 8'b00000011;
		end
	//end
end

assign drawingRequestLine = (RGBoutLine != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0;
endmodule