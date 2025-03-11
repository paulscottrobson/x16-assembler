; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		promote.asm
;		Purpose:	Promotes current address mode to absolute.
;		Created:	17th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;		Promote current address mode to absolute from zero page, return CS if not possibl
;
; ************************************************************************************************

axpromote .macro
		ldx 	#\2
		cmp 	#\1
		beq 	AXDoPromote
		.endm

AXPromoteMode:
		lda 	AXAddrMode
		.axpromote 	AXMZero,AXMAbsolute
		.axpromote 	AXMZeroX,AXMAbsoluteX
		.axpromote 	AXMZeroY,AXMAbsoluteY
		.axpromote 	AXMIndirect,AXMAbsoluteIndirect
		.axpromote 	AXMIndirectX,AXMAbsoluteIndirectX
		sec
		rts
AXDoPromote:
		stx 	AXAddrMode		
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

