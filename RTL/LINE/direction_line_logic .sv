module direction_line_logic (
	input logic clk,
	input logic resetN,
	input logic drawLine,
	input logic startOfFrame,
	input logic key2IsPressed,
	input logic key4IsPressed,
	input logic key6IsPressed,
	input logic key8IsPressed,
	input logic keyEnterIsPressed,
	input logic keyRisingEdge,
	
	output logic signed [10:0] newVelocityX,
	output logic signed [10:0] newVelocityY,
	output logic velocityWriteEnable
);

const int VELOCITY_LIMIT = 200; 
logic signed [10:0] velocityX, velocityY;
	

//getting the new velocities	
always_ff @(posedge clk or negedge resetN) begin	
	if(!resetN) begin
		velocityX <= 11'b0; 
		velocityY <= 11'b0;
	end	
	else begin
		//defaults
		velocityWriteEnable <= 1'b0;	
		
		if(drawLine) begin
			if(startOfFrame) begin
				if(key2IsPressed) begin
					velocityY <= velocityY + 1;
				end
				
				if(key8IsPressed) begin
					velocityY <= velocityY - 1;
				end
				
				if(key4IsPressed) begin
					velocityX <= velocityX - 1;
				end
				
				if(key6IsPressed) begin
					velocityX <= velocityX + 1;
				end
				
				// Velocity limiting
				if( velocityY > VELOCITY_LIMIT ) begin
					velocityY <= VELOCITY_LIMIT;
				end
				if( velocityX > VELOCITY_LIMIT ) begin
					velocityX <= VELOCITY_LIMIT;
				end
				if( velocityY < -VELOCITY_LIMIT ) begin
					velocityY <= -VELOCITY_LIMIT;
				end
				if( velocityX < -VELOCITY_LIMIT ) begin
					velocityX <= -VELOCITY_LIMIT;
				end
			end
			// Use here the keyRisingEdge signal to prevent from writing all the time to the ball
			if(keyEnterIsPressed && keyRisingEdge) begin
				velocityWriteEnable <= 1'b1;
			end
		end
			
		else begin
			velocityX <= 11'b0;
			velocityY <= 11'b0;
		end
	end
end

assign newVelocityX = velocityX;
assign newVelocityY = velocityY;

endmodule
