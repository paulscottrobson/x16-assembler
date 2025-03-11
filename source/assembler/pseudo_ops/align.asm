; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		align.asm
;		Purpose:	.align command
;		Created:	3rd September 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									.align command
;
; ************************************************************************************************

AXXAlign:	;; {.align}
		ldx 	AXOperandPos 				; get operand, must be defined even on pass 1.
		jsr 	AXExpressionDefined
		bcs 	_AXAExit 					; didn't work.
		;
		lda 	AXLeft 						; if zero, exit (align 0)
		ora 	AXLeft+1
		clc
		beq 	_AXAExit
		;
		lda 	AXLeft+1 					; copy MSB to +2 as defined, check one bit only set.
		sta 	AXLeft+2
		lda 	AXLeft 						; keep shifting left until value in carry.
_AXAShift:
		asl 	a
		rol 	AXLeft+2
		bcc 	_AXAShift
		;
		ora 	AXLeft+2  					; if other bits set it's not a legal assign
		bne 	_AXABad
		;
		lda 	AXLeft 						; decrement AXLeft, makes it a mask.
		bne 	_AXANoBorrow
		dec 	AXLeft+1
_AXANoBorrow:		
		dec 	AXLeft
		;		
_AXAlign:
		lda 	AXLeft 						; if PC & Mask zero, exit okay
		and 	AXProgramCounter
		bne 	_AXAFill
		lda 	AXLeft+1
		and 	AXProgramCounter+1
		clc
		beq 	_AXAExit
_AXAFill:		
		lda 	#$00 						; write one byte out
		jsr 	AXWriteByte
		bra 	_AXAlign

_AXABad:
		lda 	#AXERRSize
		sec		
_AXAExit:			
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

