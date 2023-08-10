; ************************************************************************************************
; ************************************************************************************************
;
;		Name : 		main.asm
;		Purpose :	Main Program
;		Date :		9th August 2023
; 		Reviewed :	No
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;								Set up the three required sections
;
; ************************************************************************************************

		* = $1000
		.dsection as16code

		* = STORAGE
		.dsection as16storage

		* = ZEROPAGE
		.dsection as16zeropage

; ************************************************************************************************
;
;										Test code boot
;
; ************************************************************************************************

		.section as16code
		jmp 	Start

		.include "build/libassembler.asm"

Start:	ldx 	#$FF
		txs

		ldx 	#0
_Copy1:		
		lda 	test,x
		jsr 	AXConvertUpper
		sta 	AXBuffer,x
		inx
		cmp 	#0
		bne 	_Copy1

		stz 	AXProgramCounter
		stz 	AXProgramCounterStart
		lda 	#$80
		sta 	AXProgramCounter+1
		sta 	AXProgramCounterStart+1
		stz 	AXProgramCounter+2
		stz 	AXProgramCounterStart+2

		ldx 	#0
		jsr 	AXExpression
		bcs 	_Bad
		lda 	AXLeft+2
		ldx 	AXLeft 
		ldy 	AXLeft+1
_Bad:
		.byte 	$DB
		jmp 	_Bad

test:	.text 	"4+7",0

		.send as16code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;
; ************************************************************************************************

