module ball_logic (
					input logic clk,
					input logic resetN,
					input logic signed [10:0] pixelX,
					input logic signed [10:0] pixelY,
					
					input logic signed [10:0] velocityX,
					input logic signed [10:0] velocityY,
					
					output logic signed [10:0] positionX,
					output logic signed [10:0] positionY,
					
					output logic signed [10:0] outVelocityX,
					output logic signed [10:0] outVelocityY
					
);


endmodule
