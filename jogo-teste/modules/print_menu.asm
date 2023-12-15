.data
.include "../assets/tiles/lamar.data"

.text
	PRINT_MENU:
			li a7,148
			li a0,175		#limpa a frame
			li a1,0
			ecall
			
			la a0,lamar	#endereço da imagem
			addi a0,a0,8	#pula os dados
			li a1,0xFF000000	#inicio da tela
			addi a1,a1,704		#ponto q vai ficar a imagem
			li t6,12800
			add a1,a1,t6
			li a2,112
			li a3,48
			li a4,0
			li a5,0
			
			
	PRINT_MENU_LOOP:		
			lw t0,0(a0)
			sw t0,0(a1)
			addi a0,a0,4
			addi a1,a1,4
			addi a4,a4,1
			blt a4,a3,PRINT_MENU_LOOP
			li a4,0
			addi a5,a5,1
			addi a1,a1,128
			blt a5,a2,PRINT_MENU_LOOP
			
			ret