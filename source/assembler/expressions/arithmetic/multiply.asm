; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		multiply.asm
;		Purpose:	16 bit multiply
;		Created:	9th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code


; ************************************************************************************************
;
;							Calculate Left := Left * Right 
;
; ************************************************************************************************

AXBinaryMult: ;; [*]
		lda 	AXLeft 						; copy left to temp
		sta 	AXMTemp
		lda 	AXLeft+1
		sta 	AXMTemp+1
		stz 	AXLeft	 					; zero left
		stz 	AXLeft+1
_AXMultLoop:
		lda 	AXMTemp 					; bit 0 of old left set ?
		and 	#1
		beq 	_AXNoAdd
		jsr 	AXBinaryAdd					; add right to left
_AXNoAdd:
		asl 	AXRight 					; shift right left
		rol 	AXRight+1
		lsr 	AXMTemp+1 					; shift old left right
		ror 	AXMTemp
		;
		lda 	AXMTemp 					; loop back if old left still non-zero
		ora 	AXMTemp+1
		bne 	_AXMultLoop		
		clc
		rts

		.send as16code

		.section as16storage
AXMTemp:
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

