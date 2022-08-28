module holes (
	input logic clk,
	input logic [10:0] pixelX,
	input logic [10:0] pixelY,
	// used to signal what is the specific hole which is requesting to draw
	output logic [2:0] holeNumber,
	// used to signal that we need to draw a hole
	output logic drawingRequestHoles,
	output logic [7:0] RGBoutHoles
);

const logic [7:0] TRANSPARENT_ENCODING = 8'hFF;
parameter int TOP_OFFSET = 0, DOWN_OFFSET = 479, LEFT_OFFSET = 0, RIGHT_OFFSET = 639;
const int BITMAP_WIDTH = 32;
const int BITMAP_HEIGHT = 32;

const logic [10:0] LEFT_PLACE = LEFT_OFFSET - BITMAP_WIDTH / 2;
const logic [10:0] MIDDLE_PLACE = (LEFT_OFFSET + RIGHT_OFFSET) / 2 - BITMAP_WIDTH / 2;
const logic [10:0] RIGHT_PLACE = RIGHT_OFFSET - BITMAP_WIDTH / 2;
const logic [10:0] TOP_PLACE = TOP_OFFSET - BITMAP_HEIGHT / 2;
const logic [10:0] DOWN_PLACE = DOWN_OFFSET - BITMAP_HEIGHT / 2;

logic [10:0] topLeftPosX, topLeftPosY;

logic [0:31][0:31] HOLE_BITMAP = {
	{32'b00000000000011111111000000000000},
	{32'b00000000011111111111111000000000},
	{32'b00000001111111111111111110000000},
	{32'b00000011111111111111111111000000},
	{32'b00000111111111111111111111100000},
	{32'b00001111111111111111111111110000},
	{32'b00011111111111111111111111111000},
	{32'b00111111111111111111111111111100},
	{32'b00111111111111111111111111111100},
	{32'b01111111111111111111111111111110},
	{32'b01111111111111111111111111111110},
	{32'b11111111111111111111111111111110},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111111},
	{32'b11111111111111111111111111111110},
	{32'b01111111111111111111111111111110},
	{32'b01111111111111111111111111111110},
	{32'b00111111111111111111111111111100},
	{32'b00111111111111111111111111111100},
	{32'b00011111111111111111111111111000},
	{32'b00001111111111111111111111110000},
	{32'b00000111111111111111111111100000},
	{32'b00000011111111111111111111000000},
	{32'b00000001111111111111111110000000},
	{32'b00000000011111111111111000000000},
	{32'b00000000000011111111000000000000}};

always_ff @(posedge clk)
begin 
	holeNumber <= 3'b0;
	topLeftPosX <= 11'b0;
	topLeftPosY <= 11'b0;

	if((TOP_PLACE + BITMAP_HEIGHT > pixelY) && (TOP_PLACE <= pixelY)) begin
		if((LEFT_PLACE <= pixelX) && (LEFT_PLACE + BITMAP_WIDTH > pixelX)) begin
			topLeftPosX <= LEFT_PLACE;
			holeNumber <= 3'd1;
		end
		else if((MIDDLE_PLACE <= pixelX) && (MIDDLE_PLACE + BITMAP_WIDTH > pixelX)) begin 
			topLeftPosX <= MIDDLE_PLACE;
			holeNumber <= 3'd2;
		end
		else if((RIGHT_PLACE <= pixelX) && (RIGHT_PLACE + BITMAP_WIDTH > pixelX)) begin 
			topLeftPosX <= RIGHT_PLACE;
			holeNumber <= 3'd3;
		end
		topLeftPosY <= TOP_PLACE;
	end
	
	else if((DOWN_PLACE + BITMAP_HEIGHT > pixelY) && (DOWN_PLACE <= pixelY)) begin
		if((RIGHT_PLACE <= pixelX) && (RIGHT_PLACE + BITMAP_WIDTH > pixelX)) begin 
			topLeftPosX <= RIGHT_PLACE;
			holeNumber <= 3'd4;
		end
		else if((MIDDLE_PLACE <= pixelX) && (MIDDLE_PLACE + BITMAP_WIDTH > pixelX)) begin 
			topLeftPosX <= MIDDLE_PLACE;
			holeNumber <= 3'd5;
		end
		else if((LEFT_PLACE <= pixelX) && (LEFT_PLACE + BITMAP_WIDTH > pixelX)) begin 
			topLeftPosX <= LEFT_PLACE;
			holeNumber <= 3'd6;
		end
		topLeftPosY <= DOWN_PLACE;
	end
	RGBoutHoles <= (HOLE_BITMAP[pixelY - topLeftPosX][pixelX - topLeftPosY]) ? 8'h00 : TRANSPARENT_ENCODING;
end 
	
assign drawingRequestHole = (holeNumber) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
endmodule
