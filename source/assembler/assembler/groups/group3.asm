; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		group3.asm
;		Purpose:	Assemble group 3 instruction (relative branches)
;		Created:	17th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Assemble group 3 instruction
;
; ************************************************************************************************

AXGroup3:
		lda 	AXBaseOpcode 				; assemble the base opcode.
		jsr 	AXWriteByte
		;

		.byte 	$DB

		jsr 	AXPass2Expression 			; get expression defined on pass 2.
		bcs 	_AXG3Exit
		;
		lda 	AXPass 						; pass 1, don't care.
		cmp 	#1
		beq 	_AXG3Exit

		sec  								; calculate relative branch
		lda 	AXLeft
		sbc 	AXProgramCounter
		tax
		lda 	AXLeft+1
		sbc 	AXProgramCounter+1
		tay

		inx 								; one short as we haven't assembled the relative branch yet.
		bne 	_AXNoCarry
		iny
_AXNoCarry:
		
		cpx 	#0 							; for 00-7F Y should be 0, for 80-FF it should be $FF
		bpl 	_AXNotBack 					; if we bump Y if X is -ve, then if zero it's a fail.
		iny 			
_AXNotBack:		
		cpy 	#0 							; so check it
		beq 	_AXOutputOffset
		;
		sec  								; if it's not out of range
		lda 	#AXERRRelative
		bra 	_AXG3Exit
		;
_AXOutputOffset:
		txa
		jsr 	AXWriteByte 				; output the offset
		clc
_AXG3Exit:		
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

