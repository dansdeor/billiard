module velocity_mux (
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

always_comb begin
	if(velocityWriteEnableHit) begin
		outVelocityX = inVelocityXHit;
		outVelocityY = inVelocityYHit;
	end
	
	else if(velocityWriteEnableLine) begin
		outVelocityX = inVelocityXLine;
		outVelocityY = inVelocityYLine;
	end
		
	else begin
		outVelocityX = 11'b0;
		outVelocityY = 11'b0;
	end
	
end

//outputs
assign WriteEnable = velocityWriteEnableHit | velocityWriteEnableLine;

endmodule
