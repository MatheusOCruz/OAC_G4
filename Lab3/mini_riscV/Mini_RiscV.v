module mini_riscV(input wire clock);
		wire [31:0] instrucao;
		wire [31:0] pc;
		//saidas reg
		wire [31:0] read_data1;
		wire [31:0] read_data2;
		// segunda entrada da ula
		wire [31:0] reg2_or_imm;
		
		wire [31:0] ula_or_mem;
		wire [31:0] write_reg_data;
		
		
		//imediato gerado
		wire [31:0] imm;
		// saida memoria de dados
		wire [31:0] dados_mem;
		
		//saida alu control
		wire [3:0] ALUCtrl;
		
		//saidas control
		wire beq;
		wire Branch;
		wire MemRead;
		wire MemToReg;
		wire [1:0] ALUOp;
		wire MemWrite;
		wire ALUSrc;
		wire reg_write;
		wire jal0;
		wire jal1;
		
		//resultados pro branch e jal
		wire beq_or_jal;
		
		//saidas ula
		wire zero;
		wire [31:0] alu_result;
		
		
		assign beq_or_jal = (Branch & zero) | jal0;
		
		pc_and_step pc_inst(
			.clock(clock),
			.imm(imm),
			.beq_or_jal(beq_or_jal),
			.pc(pc)
		);
		
		
		memoria_instrucoes memoria_instr_inst(
			.read_address(pc)
			.instrucao(instrucao)
			);

		banco_registradores banco_reg_inst(
		.clock(clock)
		.read_register1(instrucao[19:15]),
		.read_register2(instrucao[24:20]),
		.write_register(instrucao[11:7]),
		.write_data(write_reg_data),
		.reg_write(reg_write)
		.read_data1(read_data1),
		.read_data2(read_data2)
		
		);
		
		imm_gen imm_gen_inst(
			.instrucao(instrucao),
			.imm(imm)
			);
			
		mul_2 mul_ula_entrada(
			.opcao0(read_data2),
			.opcao1(imm),
			.control(ALUSrc),
			.saida(reg2_or_imm)
			);
			
			
		alu_control(
			.funct10({instrucao[14:12],instrucao[31:25]}), //supondo q func 3 vem antes do 7
			.ALUOp(ALUOp),
			.ALUCtrl(ALUCtrl)
			);
			
			
		alu(
			.ALUCtrl(ALUCtrl),
			.entrada1(read_data1),
			.entrada2(reg2_or_imm),
			.result(alu_result)
			.zero(zero)
			);
			
		memoria_dados memoria_dados_inst(
			.clock(clock),
			.address(alu_result),
			.write_data(read_data2),
			.EscreveMem(EscreveMem),
			.MemRead(MemRead),
			.read_data(dados_mem)
			);
			
		mul_2 mul_ula_or_mem(
			.opcao0(alu_result),
			.opcao1(dados_mem),
			.control(MemToReg),
			.saida(write_reg_data)
			);
			
		mul_2 write_reg(
			.opcao0(pc),
			.opcao1(ula_or_mem),
			.control(jal1),
			.saida(write_reg_data)
			);
		
		control control_inst(
			.opcode(instrucao[6:0]),
			.Branch(Branch),
			.MemRead(MemRead),
			.MemToReg(MemToReg),
			.ALUOp(ALUOp),
			.MemWrite(MemWrite),
			.ALUSrc(ALUSrc),
			.RegWrite(RegWrite),
			.jal0(jal0),
			.jal1(jal1)
			);
			
		
			
endmodule