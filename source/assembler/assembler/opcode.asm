; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		opcode.asm
;		Purpose:	Assemble an opcode
;		Created:	14th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Assemble an opcode
;
; ************************************************************************************************

AXPAssembleOpcode:
		;
		phx
		ldy 	#AXID_DataHigh 				; get the base opcode.
		jsr 	AXIGet
		sta 	AXBaseOpcode
		;
		ldy 	#AXID_DataAux 				; get the aux data (selectors for Group 2)
		jsr 	AXIGet
		sta 	AXSelector
		;
		ldy 	#AXID_DataLow 				; get the group number
		jsr 	AXIGet
		plx
		;
		cmp 	#1 							; and dispatch.
		beq 	_AXPGo1
		cmp 	#2
		beq 	_AXPGo2
		cmp 	#3
		beq 	_AXPGo3
		cmp 	#4 							
		beq 	_AXPGo4
		.byte 	$DB 					 	; this should not happen !

		
_AXPGo1:
		jmp 	AXGroup1
_AXPGo2:
		jmp 	AXGroup2
_AXPGo3:
		jmp 	AXGroup3
_AXPGo4:
		jmp 	AXGroup4

		.send as16code

		.section as16storage
AXBaseOpcode:
		.fill 	1		
AXSelector:
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

