; ************************************************************************************************
; ************************************************************************************************
;
;		Name : 		testapi.asm
;		Purpose :	API Test
;		Date :		12th August 2023
; 		Reviewed :	No
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

TestAPIHandler:
		cmp 	#0
		beq 	_TAMemInfo
		cmp 	#1
		beq 	_TAOpen
		cmp 	#3
		beq	 	_TARead
		cmp 	#4
		beq 	_TAWrite
		cmp 	#6
		beq 	_TAList
		rts
		;
		;		Memory information
		;
_TAMemInfo:
		lda 	#$94
		ldy 	#$9F
		clc
		rts		
		;
		;		Open file
		;
_TAOpen:
		lda 	#TAHSourceCode & $FF
		sta 	codeTemp
		lda 	#TAHSourceCode >> 8
		sta 	codeTemp+1
		clc
		rts
		;
		;		Read byte.
		;
_TARead:
		lda 	(codeTemp)
		sec
		beq 	_TARExit
		clc
		inc 	codeTemp
		bne 	_TARExit
		inc 	codeTemp+1
_TARExit:		
		rts
		;
		;		Listing output
		;
_TAList:
		txa
		jmp 	$FFD2
		;
		;		Write a byte 
		;
_TAWrite:
		tya
		sta 	($00,x)
		rts
		phy
		lda 	#'@'
		jsr 	AXListOut
		lda 	$02,x
		jsr 	AXLOutHex
		lda 	#'.'
		jsr 	AXListOut
		lda 	$01,x
		jsr 	AXLOutHex
		lda 	$00,x
		jsr 	AXLOutHex
		lda 	#"="
		jsr 	AXListOut
		pla
		jsr 	AXLOutHex
		lda 	#13
		jsr 	AXListOut
		rts

		;
		;		ASCII code ending with a NULL, multiple lines seperated by CR , LF or CR/LF.
		;
TAHSourceCode:
		.include "../assembler/generated/sourcebytes.dat"

		.send as16code

		.section as16zeropage
codeTemp:	
		.fill 	2
		.send as16zeropage

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

