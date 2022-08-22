module objects_mux (
						input logic	clk,
						input logic	resetN,
					
						//holes layout
						input logic drawingRequestHole_1,
						input logic	[7:0] RGBHole_1, 	
						input logic drawingRequestHole_2,
						input logic	[7:0] RGBHole_2,
						input logic drawingRequestHole_3,
						input logic	[7:0] RGBHole_3,
						input logic drawingRequestHole_4,
						input logic	[7:0] RGBHole_4,
						input logic drawingRequestHole_5,
						input logic	[7:0] RGBHole_5,
						input logic drawingRequestHole_6,
						input logic	[7:0] RGBHole_6, 
						
						// borders layout
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
		if (drawingRequestHole_1 == 1'b1) begin
			RGBOut <= RGBHole_1;
		end
		else if (drawingRequestHole_2 == 1'b1) begin
			RGBOut <= RGBHole_2;
		end
		else if (drawingRequestHole_3 == 1'b1) begin
			RGBOut <= RGBHole_3;
		end
		else if (drawingRequestHole_4 == 1'b1) begin
			RGBOut <= RGBHole_4;
		end
		else if (drawingRequestHole_5 == 1'b1) begin
			RGBOut <= RGBHole_5;
		end
		else if (drawingRequestHole_6 == 1'b1) begin
			RGBOut <= RGBHole_6;
		end
		else if (drawingRequestBorders == 1'b1) begin
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
