; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		bank.asm
;		Purpose:	.bank command
;		Created:	30th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Select bank for object code.
;
; ************************************************************************************************

AXBankCmd:	;; {.bank}

		ldx 	AXOperandPos 				; get operand, must be defined even on pass 1.
		jsr 	AXGet 						; what follows
		cmp 	#0
		beq 	_AXBCIncrement 				; if eol then just increment the bank.

		jsr 	AXPass2Expression 			; get value
		bcs 	_AXBExit
		lda 	AXLeft 						; update the bank
		sta 	AXProgramCounter+2
		clc
_AXBExit:		
		rts

_AXBCIncrement:
		inc 	AXProgramCounter+2 			; next bank
		clc
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

