/* 
   Colocar valores SW[9:0] e pressionar KEY[0] para armazenar em A
   Colocar valores SW[9:0] e pressionar KEY[1] para armazenar em B
	Pressionar KEY[2] para ver o valor de A
	Pressionar KEY[3] para ver o valor de B
	As chaves SW[4:0] definem a operação de acordo com Paramentros
	Os LEDR[4:0] mostram a Operação
*/

`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input CLK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);

	
reg [31:0] idataa,idatab,oresult;

wire [31:0] wresult;
wire ozero;


initial
	begin
		idataa<=32'b0;
		idatab<=32'b0;
		oresult<=32'b0;
	end


assign LEDR[4:0] = SW[4:0];

always @(negedge KEY[0])
		idataa <= { {22{SW[9]}}, SW[9:0] };
		
always @(negedge KEY[1])
		idatab <= { {22{SW[9]}}, SW[9:0] };

always @(posedge CLK_50)
	begin
		if(~KEY[2])
			oresult<=idataa;
		else
			if(~KEY[3])
				oresult<=idatab;
			else
				oresult<=wresult;
	end


ALU  ula1 (
	.iA(idataa), 
	.iB(idatab), 
	.iControl(SW[4:0]), 
	.oResult(wresult)
	);

Decoder7 d0 (oresult[ 3: 0],HEX0);
Decoder7 d1 (oresult[ 7: 4],HEX1);
Decoder7 d2 (oresult[11: 8],HEX2);
Decoder7 d3 (oresult[15:12],HEX3);
Decoder7 d4 (oresult[19:16],HEX4);
Decoder7 d5 (oresult[23:20],HEX5);


endmodule
