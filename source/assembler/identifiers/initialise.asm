; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		initialise.asm
;		Purpose:	Initialise the identifier store
;		Created:	11th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;							Initialise the identifier store and stack
;
; ************************************************************************************************

AXIReset:
		jsr 	AXIOpen 					; access id store
		lda 	#ASMDATA >> 8 				; save actual pages of storage
		sta 	AXIBase
		lda 	#ASMDATAEND >> 8
		sta 	AXIEnd
		;
		sta 	AXIStack+1 					; reset stack
		stz 	AXIStack
		;
		stz 	ASMDATA 					; make the first link zero, erase identifiers.
		jsr 	AXIClose 					; release ID store.
		rts

		.send as16code

		.section as16storage
AXIBase:									; MSB of identifier base area
		.fill 	1		
AXIEnd: 									; MSB of identifier end area
		.fill 	1		
AXIStack: 									; Frame stack pointe.
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

