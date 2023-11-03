module memoria_dados(
			input wire clock,
			input wire [31:0] address,
		   input wire [31:0] write_data,
		   input wire EscreveMem,
			input wire MemRead,
		   output wire [31:0] read_data
			);
			
			reg [31:0] memoria [0: 1023];
			
			always@(*) begin
				if (MemRead) begin
					read_data = memoria[address - 32'h10010000];
				end
			end
			
			always@ (posedge clock) begin
				if (EscreveMem) begin
					memoria[address - 32'h10010000] = write_data;
				end
			end

	
endmodule
			