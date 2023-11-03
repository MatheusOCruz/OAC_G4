module mul_2(
			input wire [31:0] opcao0,
			input wire [31:0] opcao1,
			input wire control,
			output wire [31:0] saida
			);
			
			always@(*) begin
				case(control)
					1'b0: saida = opcao0;
					1'b1: saida = opcao1;
				endcase
			end
			
endmodule