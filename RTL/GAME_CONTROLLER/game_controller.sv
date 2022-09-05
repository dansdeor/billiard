module game_controller(
	input logic clk,
	input logic resetN,
	input logic startOfFrame,
	
	input logic lineWriteEnable,

	input logic whiteBallStopped,
	input logic redBallStopped,

	input logic whiteBallHoleHit,
	input logic redBallHoleHit,
	input logic [2:0] redBallHoleNum,
	
	output logic whiteBallShow,
	output logic redBallShow,
	output logic drawLine,
	
	output logic [2:0] holeNumToHit,
	
	output logic [7:0] score,
	output logic [7:0] attempts,
	
	output logic resetGameN,
	output logic gameFinished
);

parameter logic [7:0] ATTEMPTS_INIT = 8'h2;

const logic [7:0] HIT_SUCCESS_SCORE = 8'h5;
const logic [7:0] WRONG_BALL_SCORE = 8'h1;

enum logic [3:0] {s_level1, s_level2, s_level3, s_level4, s_level5, s_level6, s_level7, s_level8, s_level9, s_level10} gameLevel;

logic ballsStopped;
logic anyHole;

always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		resetGameN <= 1'b0;
		gameFinished <= 1'b0;
		
		score <= 8'h0;
		attempts <= ATTEMPTS_INIT;
		
		// Getting back to level 1 on pressing resetN
		gameLevel <= s_level1;
		holeNumToHit <= 3'b1;
		anyHole <= 1'b0;

		whiteBallShow <= 1'b1;
		redBallShow <= 1'b1;
	end
	else begin
		resetGameN <= 1'b1;
		
		if(lineWriteEnable && attempts > 0) begin
			attempts <= attempts - 4'b1;
		end
		
		if(!gameFinished) begin
			if(whiteBallHoleHit && whiteBallShow) begin 
				whiteBallShow <= 1'b0;
				if(score >= WRONG_BALL_SCORE) begin
					score <= score - WRONG_BALL_SCORE;
				end
			end
			
			if(redBallHoleHit && redBallShow) begin
				redBallShow <= 1'b0;
				if(holeNumToHit == redBallHoleNum || anyHole) begin
					score <= score + HIT_SUCCESS_SCORE;
					case(gameLevel)
						s_level1: begin
							holeNumToHit <= 3'd2;
							gameLevel <= s_level2;
						end
						s_level2: begin
							holeNumToHit <= 3'd3;
							gameLevel <= s_level3;
						end
						s_level3: begin
							holeNumToHit <= 3'd4;
							gameLevel <= s_level4;
						end
						s_level4: begin
							holeNumToHit <= 3'd5;
							gameLevel <= s_level5;
						end
						s_level5: begin
							holeNumToHit <= 3'd6;
							gameLevel <= s_level6;
						end
						s_level6: begin
							// When we give a value different from 1-6 to holeNumToHit, we won't see a number on the screen
							anyHole <= 1'b1;
							holeNumToHit <= 3'd0;
							gameLevel <= s_level7;
						end
						s_level7: begin
							gameLevel <= s_level8;
						end
						s_level8: begin
							gameLevel <= s_level9;
						end
						s_level9: begin
							gameLevel <= s_level10;
						end
						s_level10: begin
							gameFinished <= 1'b1;
						end
					endcase
				end
			end
		end
		
		if(ballsStopped) begin
			if (!redBallShow || !whiteBallShow) begin
				resetGameN <= 1'b0;
				whiteBallShow <= 1'b1;
				redBallShow <= 1'b1;
			end
			
			if (attempts == 8'h0) begin
				gameFinished <= 1'b1;
			end
		end
	end
end

assign ballsStopped = (!whiteBallShow || whiteBallStopped) && (!redBallShow || redBallStopped);
assign drawLine = ballsStopped;

endmodule
