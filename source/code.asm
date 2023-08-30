* = $9000
label1

;
;		Macro definition. Expansion not yet working. Would be done with "m11 12" for example
;
m11	.macro
	lda 	#\1
	sta 	count
	.endm

sbcrt:

	lda sbcrt
	.fill 4 							; allocate 4 bytes but don't write to them, for zero page.
	sbc $abcd

	.bank 	7 							; sets current bank. The API decides what to do with it.
										; doesn't change PC as this is system dependent.

	zreg = $42	

	sbc $abcd,x 						; address mode tests
	sbc $abcd,y
	sbc (zreg)
	sbc (zreg),y
	sbc (zreg,x)
	sbc zreg,x
	sbc #zreg
	sbc zreg
	ldx sbcrt

	.bank 								; increments the bank with no operand.

	asl 	 
	asl a
	asl $04
	asl $1234
	asl $12,x
	asl $1234,x
	ldx #0
	ldy #0
	jmp $ABCD

	bra sbcrt
	bra h1 				; forward
h1:
	bra  h1


	jmp ($ABCD) 						; non standard 65C02 opcodes
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

	.include "code2.asm" 				; include text file. 
	
	jmp loop
loop:	
	jsr loop
	
	jmp 	_t3 						; _ is a local identifier with the scope of the previous
_t1: 									; global identifier (loop) to the next global identifier
	bra 	_t1
_t2
	bra 	_t2
_t3:	

	.word $ABCD,sbcrt,$5678 			; word data, can use .dw
	.binary "code3.dat" 				; include binary data
	.byte 1,2,3,4,1,>sbcrt,<sbcrt 		; byte data, can use .db
	.text 13,"Hello",0 					; mix char and byte data

	.word 0,0,0

;	.xout 								; this is for testing. It does jmp $FFFF on pass#2 so I can analyse the dump.bin file.
										; comment it out and it returns to the READY prompt.
										