; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		simple.asm
;		Purpose:	Simple arithmetic
;		Created:	9th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

binop	.macro
		lda		AXLeft
		\1 		AXRight
		sta 	AXLeft
		lda		AXLeft+1
		\1 		AXRight+1
		sta 	AXLeft+1
		clc 								; no error.
		.endm		

; ************************************************************************************************
;
;							Calculate Left :=  Left + Right
;
; ************************************************************************************************

AXBinaryAdd: ;; [+]
		clc
		.binop 	adc				
		rts

; ************************************************************************************************
;
;							Calculate Left :=  Left - Right
;
; ************************************************************************************************

AXBinarySub: ;; [-]
		sec
		.binop 	sbc				
		rts

; ************************************************************************************************
;
;							Calculate Left :=  Left AND Right
;
; ************************************************************************************************

AXBinaryAnd: ;; [&]
		.binop 	and
		rts


; ************************************************************************************************
;
;							Calculate Left :=  Left OR Right
;
; ************************************************************************************************

AXBinaryOra: ;; [|]
		.binop 	ora
		rts

; ************************************************************************************************
;
;							Calculate Left :=  Left AND Right
;
; ************************************************************************************************

AXBinaryEor: ;; [^]
		.binop 	eor
		rts

; ************************************************************************************************
;
;							Calculate Left :=  Left <> Right
;
; ************************************************************************************************

AXBinaryNotEqual: ;; [<>]
		jsr 	AXBinaryEor
		lda 	AXLeft
		eor 	AXLeft+1
		beq 	_AXBEExit
		dec 	AXLeft 
		dec 	AXLeft+1
_AXBEExit:
		clc
		rts

; ************************************************************************************************
;
;							Calculate Left :=  Left = Right
;
; ************************************************************************************************

AXBinaryEqual: ;; [=]
		jsr 	AXBinaryNotEqual
		bra 	AXNot

; ************************************************************************************************
;
;								Calculate Left := Left > Right
;
; ************************************************************************************************

AXGreater: ;; [>]
		jsr 	AXSwap

; ************************************************************************************************
;
;								Calculate Left := Left < Right
;
; ************************************************************************************************

AXLess: ;; [<]
		jsr 	AXBinarySub
		bvc 	_AXNoOverflow
		eor 	#$80
_AXNoOverflow:
		and 	#$80
		beq 	_AXIsZero
		lda 	#$FF
_AXIsZero:
		sta 	AXLeft
		sta 	AXLeft+1
		clc
		rts				

; ************************************************************************************************
;
;								Calculate Left := Left <= / >= Right
;
; ************************************************************************************************

AXLessEqual: ;; [<=]
		jsr 	AXGreater
		bra 	AXNot

AXGreaterEqual: ;; [>=]		
		jsr 	AXLess
		bra 	AXNot

; ************************************************************************************************
;
;										Left := ~ Left
;
; ************************************************************************************************

AXNot:		
		lda 	AXLeft
		eor 	#$FF
		sta 	AXLeft
		sta 	AXLeft+1
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
