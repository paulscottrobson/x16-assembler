; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		fill.asm
;		Purpose:	.fill command
;		Created:	20th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;		 Assemble fill command. .fill <n> allocates <n> bytes but doesn't output any code.
;
;						(have a look in data.inc source file for some examples)
;
; ************************************************************************************************

AXFillCmd:	;; {.fill}
AXFillCmd2:	;; {.ds}
		ldx 	AXOperandPos 				; get operand, must be defined even on pass 1.
		jsr 	AXExpressionDefined
		bcs 	_AXFExit 					; didn't work.
		;
		clc
		lda 	AXProgramCounter
		adc 	AXLeft
		sta 	AXProgramCounter
		lda 	AXProgramCounter+1
		adc 	AXLeft+1
		sta 	AXProgramCounter+1
		clc
_AXFExit:
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

