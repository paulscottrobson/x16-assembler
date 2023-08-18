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

Start:	

		.if 	TESTING==1
		jsr 	AXIReset
		jsr 	TestExpressions
		.endif

		.if 	TESTING==2
		ldx 	#TestAPIHandler & $FF
		ldy 	#TestAPIHandler >> 8
		jsr 	AXAssemble
		bcs 	_Error
		rts
		
_Error:	ldx 	#$EE
		ldy 	#$EE
		.byte 	$DB
		bra 	_Error

		.endif

		;jmp 	$FFFF
		.byte 	$DB
h1:		bra 	h1		

		.send as16code

		.if 	TESTING==1
		.include "testing/testexpr.asm"
		.endif
		.if 	TESTING==2
		.include "testing/testapi.asm"
		.endif

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

