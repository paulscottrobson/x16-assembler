; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		write.asm
;		Purpose:	Write byte A
;		Created:	14th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;										Write byte A
;
; ************************************************************************************************

AXWriteByte:
		pha 								; save registers
		phx
		phy

		ldx 	AXPass 						; output pass#2 only.
		cpx 	#2
		bne 	_AXWBBumpPC

		pha 								; add to listing
		jsr 	AXAddListingByte

		ldx 	AXProgramCounter 			; copy location
		stx 	AXTemp0
		ldx 	AXProgramCounter+1
		stx 	AXTemp0+1
		ldx 	AXProgramCounter+2
		stx 	AXTemp0+2
		ply									; char to Y.
		ldx 	#AXTemp0 					; ($00,X) is the address
		lda 	#4 							; API function 4
		jsr 	AXCallAPI
		;
_AXWBBumpPC:		
		inc 	AXProgramCounter 			; bump PC
		bne 	_AXWBSkip
		inc 	AXProgramCounter+1
_AXWBSkip:		
		ply
		plx
		pla
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
