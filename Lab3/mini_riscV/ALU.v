module alu(
		 input wire [3:0] ALUCtrl,
		 input wire signed [31:0] entrada1,
		 input wire signed [31:0] entrada2,
		 output wire [31:0] result,
		 output wire zero);
		 
		 always @(*) begin
			case (ALUCtrl) 
				ADDOP: result = entrada1 + entrada2;
				SUBOP: result = entrada1 - entrada2;
				ANDOP: result = entrada1 & entrada2;
				OROP:	 result = entrada1 | entrada2;
				SLTOP: result = (entrada1 < entrada2) ? {31'b0, 1'b1} : 32'b0;
				OPXOR: result = entrada1 ^ entrada2;
				default: result = 32'b0;
			endcase
			
			zero = (result == 32'b0) ? 1'b1 : 1'b0;
		
		 end
		 
	
endmodule