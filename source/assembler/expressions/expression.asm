; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		expression.asm
;		Purpose:	Evaluate expression.
;		Created:	19th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Evaluate expression at Buffer,X.
;
;		  Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;
; ************************************************************************************************

AXExpression:
		lda 	#0 							; start at precedence level 0.
AXExpressionAtA:
		pha 								; save precedence level.
		jsr 	AXTerm 						; get a term.
		bcc 	_AXEExpressionLoop
		ply 								; throw precedence, return error in A.
		rts

; ================================================================================================
;
;		Main expression loop. Precedence is on the stack, and Buffer,X points to character
;
; ================================================================================================

_AXEExpressionLoop:		
		lda 	AXBuffer,x 					; skip spaces.
		inx
		cmp 	#' '
		beq 	_AXEExpressionLoop
		dex

		; ========================================================================================
		;
		;							Identify the binary operator, if any.
		;
		; ========================================================================================

		ldy 	#(0-2) & $FF 						
		stx 	AXOperatorPos				; save operator position in case rejected.
_AXFindBinOp:		
		iny 								; pre-increment.
		iny
		lda 	AXBinaryOperatorList,y 		; first character to match
		beq 	_AXExitPop 					; if end of table pop and exit, okay.
		cmp 	AXBuffer,x 					; if wrong, go to next
		bne 	_AXFindBinOp
		;
		lda 	AXBinaryOperatorList+1,y 	; second character to match
		beq 	_AXConsume1 				; if zero, then matched a single one, and consume 1.
		cmp 	AXBuffer,x 					; if wrong, go to next.
		bne 	_AXFindBinOp
		inx 								; consume 2 character
_AXConsume1:
		inx 								; or 1 if a single character.
		tya 								; halve the operator code.
		lsr 	a
		tay		

		; ========================================================================================
		;
		;					Exit if the operator precedence >= required precedence
		;
		; ========================================================================================

		pla 								; required precedence
		cmp 	AXPrecedence,y 				; if >= then exit
		bcs 	_AXPrecFail
		pha 								; save the levels precedence.
		phy 								; save the operator ID

		; ========================================================================================
		;
		;									Evaluate the RHS
		;
		; ========================================================================================

		lda 	AXLeft 						; push AXLeft on the stack
		pha
		lda 	AXLeft+1
		pha
		lda 	AXLeft+2
		pha

		lda 	AXPrecedence,y 				; evaluate the RHS at the precedence of the operator or higher.
		jsr 	AXExpressionAtA
		bcs 	_AXFailedRHS

		jsr 	AXSwap 						; put the RHS into the right side.
		pla 								; and restore AXLeft
		sta 	AXLeft+2
		pla
		sta 	AXLeft+1
		pla
		sta 	AXLeft

		; ========================================================================================
		;
		;						Call the actual code to execute the operator
		;
		; ========================================================================================

		pla 								; operator ID
		asl 	a 							; now index into vector table
		phx 								; save buffer pos so we can use indexing
		tax
		jsr 	_AXDoOperator 				; call the operator code.
		plx 								; restore buffer position.
		bcc 	_AXEExpressionLoop 			; and go round again if no error
		ply 								; throw the precedence on the stack.
		sec
		rts

_AXDoOperator:
		jmp 	(AXBinaryVectors,x)
		;
		;			Come here if RHS calc failed.
		;
_AXFailedRHS:	 							; rhs failed. throw the saved left, operator ID,and the precedence level.
		ply
		ply
		ply
		ply
		ply
		sec
		rts
		;
		;			Here if failed precedence test (not an error)
		;
_AXPrecFail:
		ldx 	AXOperatorPos 				; precedence fail, undo operator consume
		clc
		rts
		;
		;			Here if unknown operator
		;
_AXExitPop:
		pla
		clc
		rts

		.send as16code

		.section as16storage
AXOperatorPos:								; operator offset in buffer.
		.fill 	1		
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

