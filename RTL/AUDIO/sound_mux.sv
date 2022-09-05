module sound_mux (

	//input logic clk,
	//input logic resetN,

	input logic key2IsPressed,
	input logic key4IsPressed,
	input logic key6IsPressed,
	input logic key8IsPressed,
	input logic keyEnterIsPressed,
	
	input logic holeColOccured,
	input logic borderColOccured,
	input logic ballToBallcolOccured
	
	output logic keyXAudioRequest,
	output logic keyYAudioRequest,
	output logic keyEnterAudioRequest,
	output logic holeColAudioRequest,
	output logic borderColAudioRequest,
	output logic ballToBallColAudioRequest
	
);

always_comb //or negedge resetN) //do I need non-blocking implamation?
begin
	/*if(!resetN) begin
		keyAudioRequest <= 1'b0;
		holeColAudioRequest <= 1'b0;
		borderColAudioRequest <= 1'b0;
	end*/
	
	//defaults
	keyAudioRequest = 1'b0;
	holeColAudioRequest = 1'b0;
	borderColAudioRequest = 1'b0;
	
	//else begin
		if (keyEnterIsPressed) begin
			keyEnterRequest = 1'b1;
		end
		
		if( key4IsPressed || key6IsPressed ) begin
			keyXAudioRequest = 1'b1;
		end
	
		if( key2IsPressed || key8IsPressed ) begin
			keyXAudioRequest = 1'b1;
		end

		if (holeColOccured) begin
			holeColAudioRequest = 1'b1;
		end
		
		if (borderColOccured) begin
			borderColAudioRequest = 1'b1;
		end
		
		if (ballToBallcolOccured) begin
			ballToBallColAudioRequest = 1'b1;
		end
	
		
	//end
end

endmodule
