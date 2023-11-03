

parameter
//parametros dos opcode
		OPLW     = 7'h03,
		OPSW     = 7'h23,
		OPBEQ    = 7'h63,
		OPJAL    = 7'h6f,
		OPTIPO-R = 7'h33,
		OPTIPO-I = 7'h13,
		
// parametros ALU		
		ADDOP = 4'b0010,
		OPSUB = 4'b0110,
		OPAND = 4'b0000,
		OPOR  = 4'b0001,
		OPSLT = 4'b0111,
		OPXOR = 4'b1000; // dps eu vejo esse