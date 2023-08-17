; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		helper.asm
;		Purpose:	Expression helpers
;		Created:	14th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;				Evaluate expression at Buffer,X. Undefined identifiers => error.
;
;		  Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;
; ************************************************************************************************

AXExpressionDefined:
		jsr 	AXExpression 				; evaluate
		bcs 	_AXDExit 					; some other error.
		lda 	AXLeft+2 					; check defined.
		bpl 	_AXDExit 					; okay.

		sec 								; return undefined error
		lda 	#AXERRUndefined
_AXDExit:
		rts

; ************************************************************************************************
;
;			Evaluate expression at Buffer,X. Undefined identifiers => error on pass2 
;
;		  Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;							On error, the default value is set to $FFFF
;
; ************************************************************************************************

AXPass2Expression:
		jsr 	AXExpression 				; evaluate
		bcs 	_AXDExit 					; some other error.
		lda 	AXLeft+2 					; check defined.
		bpl 	_AXDExit 					; okay.

		lda 	AXPass 						; if pass 1, that's okay even if undefined.
		cmp 	#1
		clc
		beq 	_AXDExit

		lda 	#$FF 						; set the default value to $FFFF
		sta 	AXLeft
		sta 	AXLeft+1

		sec 								; return undefined error
		lda 	#AXERRUndefined
_AXDExit:
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
