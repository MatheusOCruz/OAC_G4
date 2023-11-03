module pc_and_step(
			input wire clock,
			input wire [31:0] imm,
			input beq_or_jal,
			output [31:0] pc
			); // nao sou bom no nome, paciencia 
			
			reg [31:0] pc;
			wire [31:0] next_pc;
			
			initial begin
				pc = 32'h00400000; // enredeco inicial da mem de instrucoes
			end
			
			always@(*) begin
				case(beq_or_jal)
					1'b1: next_pc = pc+ imm;
					1'b0: next_pc = pc+4;
				endcase
			end
			
			always@(posedge clock) begin
				pc <= next_pc;
			end
			
endmodule