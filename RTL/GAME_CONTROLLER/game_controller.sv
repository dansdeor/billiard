/*
module game_controller(
	input logic clk,
	input logic resetN,
	
	input logic enterPressed,

	input logic whiteBallStopped,
	input logic redBallStopped,

	input logic whiteBallHoleHit,
	input logic redBallHoleHit,

	input logic [2:0] redBallHoleNum,
	
	output logic whiteBallShow,
	output logic redBallShow,
	output logic drawLine,
	
	output logic [2:0] holeNumToHit,
	output logic resetGameN
);

//TODO: give signal for line draw

const int HIT_SUCCESS_SCORE = 0x10;
const int WRONG_BALL_SCORE = 0x8;


enum logic [2:0] {s_level1, s_level2, s_level3, s_level4, s_level5, s_level6, s_anyHole} gameLevel_ps, gameLevel_ns;

logic [7:0] score;
logic [3:0] attempts;


always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		score <= 8'b0;
		attempts <= 4'd10;
		holeNumToHit <= 3'b1;
		gameLevel_ns <= s_level1;
		
		whiteBallShow <= 1'b1;
		redBallShow <= 1'b1;
	end
	resetGameN <= 1'b1;
	gameLevel_ps <= gameLevel_ns;
	
	if(enterPressed) begin
		attempts <= attempts - 4'b1;
	end
	
	if(whiteBallHoleHit) begin 
		whiteBallShow <= 1'b0;
		if(score >= WRONG_BALL_SCORE) begin
			score <= score - WRONG_BALL_SCORE;
		end
	end
	
	if(redBallHoleHit) begin
		redBallShow <= 1'b0;
		if(holeNumToHit == redBallHoleNum) begin
			score <= score + HIT_SUCCESS_SCORE;
			case(gameLevel_ps) begin
				s_level1: begin
					holeNumToHit <= 3'd2;
					gameLevel_ns <= s_level2;
				end
				s_level2: begin
					holeNumToHit <= 3'd3;
					gameLevel_ns <= s_level3;
				end
				s_level3: begin
					holeNumToHit <= 3'd4;
					gameLevel_ns <= s_level4;
				end
				s_level4: begin
					holeNumToHit <= 3'd5;
					gameLevel_ns <= s_level5;
				end
				s_level5: begin
					holeNumToHit <= 3'd6;
					gameLevel_ns <= s_level6;
				end
				s_level6: begin
					// When we give a value different from 1-6 to holeNumToHit, we won't see a number on the screen
					holeNumToHit <= 3'd0;
					gameLevel_ns <= s_anyHole;
				end
			endcase
		end
	end
	
	if((whiteBallStopped && !redBallShow) || (!whiteBallShow && redBallStopped)) begin
		resetGameN <= 1'b0;
	end

	if(!attempts) begin
		holeNumToHit <= 3'd0;
		gameLevel_ns <= s_anyHole;
	end
endmodule
*/