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
