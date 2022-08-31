module velocity_mux (
	input logic clk, 
	input logic velocityWriteEnableHit,
	input logic velocityWriteEnableLine,
	input logic signed [10:0] inVelocityXLine,
	input logic signed [10:0] inVelocityYLine,
	input logic signed [10:0] inVelocityXHit,
	input logic signed [10:0] inVelocityYHit,

	output logic signed [10:0] outVelocityX,
	output logic signed [10:0] outVelocityY,
	output logic WriteEnable
);

logic signed [10:0] velocityX;
logic signed [10:0] velocityY; 

always_ff @(posedge clk)
begin	

	if(velocityWriteEnableHit) begin
		velocityX <= inVelocityXHit;
		velocityY <= inVelocityYHit;
	end
	
	else if(velocityWriteEnableLine) begin
		velocityX <= inVelocityXLine;
		velocityY <= inVelocityYLine;
	end
		
end

//outputs
assign outVelocityX = velocityX;
assign outVelocityY = velocityY;
assign WriteEnable = velocityWriteEnableHit | velocityWriteEnableLine;

endmodule 