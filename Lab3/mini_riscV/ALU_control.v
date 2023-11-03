module alu_control (
			input wire [9:0] funct10,
			input wire [1:0] ALUOp,
			output wire [3:0] ALUCtrl
			);
	
			
			always @(*) begin
				case(ALUOp)
					2'b00 : ALUCtrl = ADDOP;
					2'b01 : ALUCtrl = SUBOP;
					2'b10 : 
						case(funct10)
								FUNADD: ALUCtrl = ADDOP;
								FUNSUB: ALUCtrl = SUBOP;
								FUNAND: ALUCtrl = ANDOP;
								FUNOR:  ALUCtrl = OROP;
								FUNSLT: ALUCtrl = SLTOP;
								FUNXOR: ALUCtrl = XOROP;
								default: ALUCtrl = 4'b0;
						endcase
					default: 4'b0;
				
				endcase

endmodule