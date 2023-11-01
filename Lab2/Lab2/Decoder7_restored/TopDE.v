/* TopDE.v */

/*****************************************
*    UnB - OAC - Prof. Marcus Lamar      *
*    Laboratório 2 - DE1-SoC   			  *
*    Exemplo 1                           *
*****************************************/

// Este exemplo visa apresentar as facilidades de IO
// da plataforma de desenvolvimento Intel - DE1-SoC


module TopDE (
	input 		 CLOCK_50,
	input  [9:0] SW, 
	input  [3:0] KEY,
	output [9:0] LEDR, 
	output [6:0] HEX0, HEX1 
	);


	assign LEDR[0] = KEY[0];
	assign LEDR[1] = ~KEY[0];
	assign LEDR[2] = KEY[1];
	assign LEDR[3] = ~KEY[1];
	assign LEDR[4] = KEY[2];
	assign LEDR[5] = ~KEY[2];
	assign LEDR[6] = KEY[3];
	assign LEDR[7] = ~KEY[3];


	xor x1 (LEDR[8],SW[9],SW[8]); // Exemplos de definição de portas lógicas
	assign LEDR[9]=SW[9]^SW[8];
		
	decoder7 u0 (.In(SW[3:0]),  .Out(HEX0), .Clk(CLOCK_50));
	decoder7 u1 (.In(SW[7:4]),  .Out(HEX1), .Clk(CLOCK_50));

endmodule
