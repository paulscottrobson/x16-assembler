* = $9000
sbcrt:
	.text 13,"Hello",0
	lda sbcrt
	.fill 4
	sbc $abcd
	zreg = $42	
	sbc $abcd,x
	sbc $abcd,y
	sbc (zreg)
	sbc (zreg),y
	sbc (zreg,x)
	sbc zreg,x
	sbc #zreg
	sbc zreg
	ldx sbcrt
	bra sbcrt
	bra h1 				; forward
h1:
	bra  h1

	asl 	
	asl a
	asl $04
	asl $1234
	asl $12,x
	asl $1234,x
	ldx #0
	ldy #0
	jmp $ABCD

	jmp ($ABCD)
	jmp ($ABCD,x)
	ldx $1234,y
	ldx $56,y
	inc
	dec
	inc a
	dec a
	bit #$12
	stz $1234
	stz $5667,x
;	stz $1234,y
	.include "code2.asm"
	
	jmp loop
loop:	
	jsr loop	
	
	.word $ABCD,sbcrt,$5678
	.binary "code3.dat"
	.byte 1,2,3,4,1,>sbcrt,<sbcrt
	.include "code2.asm"
	.text 13,"Hello",0
"
	.word 0,0,0