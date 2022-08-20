module objects_mux (
						input logic	clk,
						input logic	resetN,	
						// board layout
						input logic drawingRequestBorders,
						input logic	[7:0] RGBBorders,
						// board layout
						input logic drawingRequestBoard,
						input logic	[7:0] RGBBoard, 

						output logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut <= 8'b0;
	end
	
	else begin
		if (drawingRequestBorders == 1'b1) begin
			RGBOut <= RGBBorders;
		end
		else if (drawingRequestBoard == 1'b1) begin
			RGBOut <= RGBBoard;
		end
		else begin
			RGBOut <= 8'b0;
		end
	end
end

endmodule
