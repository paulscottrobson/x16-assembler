; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		divide.asm
;		Purpose:	16 bit divide (unsigned)
;		Created:	10th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code


; ************************************************************************************************
;
;							Calculate Left := Left / Right 
;
; ************************************************************************************************

AXBinaryDivide: ;; [/]
		lda 	AXRight 					; check divide by zero
		ora 	AXRight+1
		beq 	_AXDivZero
		;
		stz 	AXDTemp 					; A = 0
		stz 	AXDTemp+1
		;
		ldy 	#16 						; iteration count.
_AXDivLoop:
		phy
		;
		asl 	AXLeft 						; shift AQ left.
		rol 	AXLeft+1
		rol 	AXDTemp
		rol 	AXDTemp+1
		;
		sec 								; A-M => A:Y
		lda 	AXDTemp
		sbc 	AXRight
		tay
		lda 	AXDTemp+1
		sbc 	AXRight+1
		bcc 	_AXDivNext 					; if A < M exit
		;
		sta 	AXDTemp+1 					; A = A - M
		sty 	AXDTemp
		inc 	AXLeft 						; set bit 0 of the result.
_AXDivNext:
		ply
		dey 
		bne 	_AXDivLoop
		clc
		rts		

_AXDivZero:
		lda 	#AXERRDivZero
		sec
		rts

; ************************************************************************************************
;
;							Calculate Left := Left % Right 
;
; ************************************************************************************************

AXBinaryModulus: ;; [%]
		jsr 	AXBinaryDivide
		bcs 	_AXBMExit
		lda 	AXDTemp
		sta 	AXLeft
		lda 	AXDTemp+1
		sta 	AXLeft+1
		clc
_AXBMExit:		
		rts

		.send as16code

		.section as16storage
AXDTemp:
		.fill 	2		
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

