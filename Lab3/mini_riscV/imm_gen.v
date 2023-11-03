module imm_gen(
		 input wire [31:0] instrucao,
		 output wire [31:0] imm
		 );
		
			
		 wire [6:0] opcode = instrucao[6:0];	
		 always @(*) begin
			case (opcode)
				OPLW:     imm = {20{instrucao[31]}, instrucao[31:20]};
				OPSW:     imm = {20{instrucao[31]}, instrucao[31:25], instrucao[11:7]};
				OPBEQ:    imm = {20{instrucao[31]}, instrucao[7],instrucao[30:25], instrucao[11:8],1'b0} // 0 defaut pra n usar shift left
				OPJAL:    imm = {12{instrucao[31]},instrucao[19:12],instrucao[20],instrucao[30:21],1'b0} // mema coisa
				OPTIPO-I: imm = {20{instrucao[31]}, instrucao[31:20]};
				default: imm = 32'h00000000;
			endcase
		 
		 end
		 
endmodule