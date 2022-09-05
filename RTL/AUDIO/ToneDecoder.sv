module	ToneDecoder	(	
			input clk,
			input resetN,
			input startOfFrame,
			
			input logic keyXAudioRequest,
			input logic keyYAudioRequest,
			input logic keyEnterAudioRequest,
			input logic holeColAudioRequest,
			input logic borderColAudioRequest,
			input logic ballToBallColAudioRequest,
			output logic [9:0] preScaleValue
);

//---------------VALUES for 25MHz------------------------
/*
10'h175,   // decimal =373.27      Hz =261.62  do    25_000_000/256/<FREQ_Hz>
10'h160,   // decimal =352.32      Hz =277.18  doD
10'h14C,   // decimal =332.54      Hz =293.66  re
10'h139,   // decimal =313.88      Hz =311.12  reD
10'h128,   // decimal =296.26      Hz =329.62  mi
10'h117,   // decimal =279.64      Hz =349.22  fa
10'h107,   // decimal =263.93      Hz =370    faD
10'h0F9,   // decimal =249.12      Hz =392    sol
10'h0EB,   // decimal =235.14      Hz =415.3  solD
10'h0DD,   // decimal =221.94      Hz =440    La
10'h0D1,   // decimal =209.49      Hz =466.16  laD
10'h0C5,   // decimal =197.73      Hz =493.88  si
10'h1A2,   // decimal =418.98      Hz =233.08  laD
10'h18B,   // decimal =395.46      Hz =246.94  si
*/
	
parameter int DURATION = 2;
	
int durationCounter;
	
always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		durationCounter <= 0;
	end
	else begin
		if(startOfFrame) begin
			if(durationCounter > 0) begin
				durationCounter <= durationCounter - 1;
			end
			else begin
				preScaleValue <= 10'h00;//none
			end
		end

		if(keyEnterAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h175; //do
		end
		
		else if(keyXAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h14C; //re
		end
	
		else if(keyYAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h128; //mi
		end

		else if(holeColAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h0DD; //La
		end
		
		else if(borderColAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h18B; //si
		end
		
		else if(ballToBallColAudioRequest) begin
			durationCounter <= DURATION;
			preScaleValue <= 10'h117; //fa
		end
	end
end

endmodule
