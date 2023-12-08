.text
ANIMA_ESTATICO:
	
	li t0,13	
	blt a6,t0,END_ESTATICO  #checa se o tile deve ter animação
	
	la t0,anim_frame
	lw t1,4(t0)
	beqz t1,END_ESTATICO
			
	csrr t1,time
	sw t1,0(t0)
	
	li t0,2
	rem t0,a6,t0
	beqz t0,SUBTRAI
	b ADICIONA
	
SUBTRAI:

	addi a6,a6,-1
	sb a6,0(s0)
	b END_ESTATICO

ADICIONA:
	
	addi a6,a6,1
	sb a6,0(s0)

END_ESTATICO:
	
	tail VOLTA_ESTATICO