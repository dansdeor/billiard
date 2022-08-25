module ball_draw (
					input logic clk,
					input logic signed [10:0] pixelX,
					input logic signed [10:0] pixelY,
					input logic signed [10:0] ball_top_left_posX,
					input logic signed [10:0] ball_top_left_posY,
					
					output logic drawingRequestBall,
					output logic [7:0] RGBoutBall
);

// generating the bitmap 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hff ;// RGB value in the bitmap representing a transparent pixel
//parameter logic [10:0] ball_top_left_posX = 11'd10;   //inside paramater for deciding the RGBoutball value
//parameter logic [10:0] ball_top_left_posY = 11'd30; 
const int OBJECT_cOLORS_X= 11'd32; 				   //const value for deciding the RGBoutball value
const int OBJECT_cOLORS_Y= 11'd32;
  
logic[0:31][0:31][7:0] object_colors = {
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
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
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hfe,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}};


 

always_ff@(posedge clk) 
begin 
	//starting position, when we will have levels\rounds the if condition will be changed
	RGBoutBall <= TRANSPARENT_ENCODING ; // default  
	if ((ball_top_left_posX <= pixelX) && (ball_top_left_posX + OBJECT_cOLORS_X > pixelX) && (ball_top_left_posY + OBJECT_cOLORS_Y > pixelY) && (ball_top_left_posY <= pixelY) ) 
		begin // inside an external bracket  
		RGBoutBall <= object_colors[pixelY - ball_top_left_posY][pixelX - ball_top_left_posX]; // gets the color from the bitmap
		end
end 
 
//////////--------------------------------------------------------------------------------------------------------------= 
// decide if to draw the pixel or not 
assign drawingRequestBall = (RGBoutBall != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
 
endmodule
