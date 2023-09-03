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
		lda 	#AXAPISetup 				; get the start & end
		jsr 	AXCallAPI 
		sta 	AXIBase
		sty 	AXIEnd
		;
		sty 	AXIStack+1 					; reset stack
		stz 	AXIStack
		;
		jsr 	AXIOpen 					; access id store
		;
		lda 	AXIBase 					; erase the user definitions.
		sta 	AXTemp0+1
		stz 	AXTemp0
		lda 	#0
		sta 	(AXTemp0)
		stz 	AXIMemory 					; clear out of memory flag.
		;
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
AXIMemory: 									; set when out of memory.
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

