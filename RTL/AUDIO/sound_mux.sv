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
	
	output logic keyAudioRequest,
	output logic holeColAudioRequest,
	output logic borderColAudioRequest
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
		if (key2IsPressed || key4IsPressed || key6IsPressed || key8IsPressed || keyEnterIsPressed) begin
			keyAudioRequest = 1'b1;
		end
		else if (holeColOccured) begin
			holeColAudioRequest = 1'b1;
		end
		else if (borderColOccured) begin
			borderColAudioRequest = 1'b1;
		end
	//end
end

endmodule
