module sound_mux (

	input logic keyRisingEdge,
	input logic key2IsPressed,
	input logic key4IsPressed,
	input logic key6IsPressed,
	input logic key8IsPressed,
	input logic keyEnterIsPressed,
	input logic holeColOccured,
	input logic borderColOccured,
	input logic ballToBallcolOccured,
	
	output logic keyXAudioRequest,
	output logic keyYAudioRequest,
	output logic keyEnterAudioRequest,
	output logic holeColAudioRequest,
	output logic borderColAudioRequest,
	output logic ballToBallColAudioRequest
	
);

always_comb begin
	//defaults
	keyXAudioRequest = 1'b0;
	keyYAudioRequest = 1'b0;
	keyEnterAudioRequest = 1'b0;
	holeColAudioRequest = 1'b0;
	borderColAudioRequest = 1'b0;
	ballToBallColAudioRequest = 1'b0;
	
	if (keyRisingEdge && keyEnterIsPressed) begin
		keyEnterAudioRequest = 1'b1;
	end
	
	if(key4IsPressed || key6IsPressed) begin
		keyXAudioRequest = 1'b1;
	end

	if(key2IsPressed || key8IsPressed) begin
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
end

endmodule
