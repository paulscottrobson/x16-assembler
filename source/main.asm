; ************************************************************************************************
; ************************************************************************************************
;
;		Name : 		main.asm
;		Purpose :	Main Program (wrapper for testing with api in api directory)
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
		;
		;		This tests expressions
		;
		.if 	TESTING==1
		ldx 	#<DummyAPI 			; set up dummy so reset works.
		ldy 	#>DummyAPI
		stx 	AXAPI 						
		sty 	AXAPI+1
		jsr 	AXIReset
		jsr 	TestExpressions

DummyAPI:		 					; just enough to make it work !!
		lda 	#$94
		ldy 	#$9F
		clc
		rts		

		.endif
		;
		;		This is what is normally run, assembles code as received via API.
		;
		.if 	TESTING==2
		ldx 	#SampleAPIHandler & $FF
		ldy 	#SampleAPIHandler >> 8
		jsr 	AXAssemble
		rts
		.endif

		.send as16code

		.if 	TESTING==1
		.include "testing/testexpr.asm"
		.endif
		.if 	TESTING==2
		.include "api/api.asm"
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
