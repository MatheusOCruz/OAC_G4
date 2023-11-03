module memoria_instrucoes(
			input wire [31:0] read_address,
			output wire [31:0] instrucao
			);
			
			reg [31:0] memoria [0:1023];
			
			always@(*)begin
				instrucao = memoria[read_address - 32'h00400000];
			end

endmodule
			