module banco_registradores (
		 input wire clock,
		 input wire [4:0] read_register1, 
		 input wire [4:0] read_register2, 
		 input wire [4:0] write_register, 
		 input wire [31:0] write_data,
		 input wire reg_write,
		 output wire [31:0] read_data1,
		 output wire [31:0] read_data2
		 );
		 
		 
		 reg [31:0] registradores [31:0];
		 
		 initial begin
			registradores[2] = 32'h100103FC; // stack pointer
			registradores[3] = 32'h10010000; // global pointer
		 end
			
		 
		 always @(posedge clock) begin
		 
			if (reg_write && (write_register != 0) begin
			
				registradores[write_register] <= write_data;
				
			end
		 
		 end
		 
		 always @* begin
			read_data1 = registradores[read_register1];
			read_data2 = registradores[read_register2];
		 end
		 
		 

endmodule