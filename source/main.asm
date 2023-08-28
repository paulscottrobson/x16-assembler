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
		ldx 	#<DummyAPI 			; set up dummy so reset works.
		ldy 	#>DummyAPI
		stx 	AXAPI 						
		sty 	AXAPI+1
		jsr 	AXIReset
		jsr 	TestExpressions

DummyAPI:		
		lda 	#$94
		ldy 	#$9F
		clc
		rts		

		.endif

		.if 	TESTING==2
		ldx 	#TestAPIHandler & $FF
		ldy 	#TestAPIHandler >> 8
		jsr 	AXAssemble
		rts
		.endif


		;jmp 	$FFFF
		.byte 	$DB
h1:		bra 	h1		

		.send as16code

		.if 	TESTING==1
		.include "testing/testexpr.asm"
		.endif
		.if 	TESTING==2
		.include "api/testapi.asm"
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
