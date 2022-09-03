module hole_collision (
	input logic clk,
	input logic resetN,

	input logic ballDR,
	input logic holesDR,
	input logic [2:0] holeNumber,
	
	output logic holeHit,
	output logic [2:0] holeNumberHit
);

logic flag;

always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		flag <= 1'b1;
		holeHit <= 1'b0;
		holeNumberHit <= 3'b0;
	end
	else begin
		if(ballDR && holesDR && flag) begin
			flag <= 1'b0;
			holeHit <= 1'b1;
			holeNumberHit <= holeNumber;
		end
		else if (!(ballDR && holesDR)) begin
			flag <= 1'b1;
			holeHit <= 1'b0;
		end
	end
end

endmodule
