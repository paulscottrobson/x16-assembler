; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		word.asm
;		Purpose:	.word command
;		Created:	21st August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Assemble .word command
;
; ************************************************************************************************

AXWordCmd:	;; {.word}
AXWordCmd2:	;; {.dw}
		ldx 	AXOperandPos 				; get operand, must be defined even on pass 1.
;
_AXWLoop:
		jsr 	AXPass2Expression 			; get value
		bcs 	_AXWExit

		lda 	AXLeft 						; output the word.
		jsr 	AXWriteByte
		lda 	AXLeft+1
		jsr 	AXWriteByte

		jsr 	AXGet 						; get next
		inx
		cmp 	#","
		beq 	_AXWLoop
		cmp 	#0
		bne 	_AXWSyntax
		clc
_AXWExit:		
		rts
_AXWSyntax:
		lda 	#AXERRSyntax
		sec
		rts


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

