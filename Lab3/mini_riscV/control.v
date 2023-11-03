module control(
			input wire [6:0] opcode,
			output wire Branch,
			output wire MemRead,
			output wire MemToReg,
			output wire [1:0] ALUOp,
			output wire MemWrite,
			output wire ALUSrc,
			output wire RegWrite,
			output wire jal0,
			output wire jal1
			);
			
			always @(*) begin
				case(opcode)
					OPTIPO-R: begin
						ALUSrc   = 1'b0;
						MemToReg = 1'b0;
						RegWrite = 1'b1;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						ALUOp    = 2'b10;
						jal1     = 1'b0;
						jal0     = 1'b0;
					end
					
					OPTIPO-I: begin
						ALUSrc   = 1'b1;
						MemToReg = 1'b0;
						RegWrite = 1'b1;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						ALUOp    = 2'b10;
						jal1     = 1'b0;
						jal0     = 1'b0;
					end
					
					OPLW: begin
						ALUSrc   = 1'b1;
						MemToReg = 1'b1;
						RegWrite = 1'b1;
						MemRead  = 1'b1;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						ALUOp    = 2'b00;
						jal1     = 1'b0;
						jal0     = 1'b0;
					end
					
					OPSW: begin
						ALUSrc   = 1'b1;
						MemToReg = 1'_;
						RegWrite = 1'b0;
						MemRead  = 1'b0;
						MemWrite = 1'b1;
						Branch   = 1'b0;
						ALUOp    = 2'b00;
						jal1     = 1'b0;
						jal0     = 1'b0;
					end
					
					OPBEQ: begin
						ALUSrc   = 1'b0;
						MemToReg = 1'_;
						RegWrite = 1'b0;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						ALUOp    = 2'b01;
						jal1     = 1'b0;
						jal0     = 1'b0;
					end
					
					OPJAL: begin
						ALUSrc   = 1'_;
						MemToReg = 1'_;
						RegWrite = 1'b1;
						MemRead  = 1'b0;
						MemWrite = 1'b0;
						Branch   = 1'b0;
						ALUOp    = 2'b__;
						jal1     = 1'b1;
						jal0    = 1'b1;
					end
				endcase
			end
			 
			
endmodule