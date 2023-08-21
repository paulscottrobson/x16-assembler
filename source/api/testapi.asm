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
		beq	 	_TAReadChar
		cmp 	#4
		beq 	_TAWriteByte
		cmp 	#6
		beq 	_TAListChar
		rts

; ************************************************************************************************
;
;							Memory information and initialisation
;
; ************************************************************************************************

_TAMemInfo:
		lda 	#$94
		ldy 	#$9F
		clc
		rts		

_TAOpen:
		jmp 	TAOpen
_TAClose:
		jmp 	TAClose
_TAReadChar:
		jmp  	TAReadChar
_TAWriteByte
		jmp 	TAWriteByte
_TAListChar:
		jmp 	TAListChar

		.include "apilist.asm"
		.include "apiwrite.asm"
		.include "apifile.asm"

		.send as16code

		.section as16storage
TAHandleTracker:
		.fill	 1			
		.send as16storage

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

