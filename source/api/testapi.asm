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
		cmp 	#2
		beq 	_TAClose
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
		lda 	#_FileNameEnd-_FileName
		ldx 	#<_FileName
		ldy 	#>_FileName
		jsr 	$FFBD 						; SETNAM

		lda 	#15
		ldx 	#8
		ldy 	#0
		jsr 	$FFBA 						; set LFS

		jsr 	$FFC0 						; OPEN, returns CS on failure.
_TAOExit:		
		rts

_FileName:
		.text 	'CODE.ASM'
_FileNameEnd:
		;
		;		Close file
		;
_TAClose:
		lda 	#15 							; CLOSE
		jsr 	$FFC3
		clc
		rts		
		;
		;		Read byte.
		;
_TARead:
		ldx 	#15							; CHKIN
		jsr 	$FFC6 
		jsr 	$FFCF 						; CHRIN
		pha
		jsr 	$FFB7 						; READST
		and 	#64
		clc
		beq 	_TARExit
		sec
_TARExit:		
		php
		jsr 	$FFCC  						; CLRCHN
		plp	
		pla
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

