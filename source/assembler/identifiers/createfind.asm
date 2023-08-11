; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		createfind.asm
;		Purpose:	Create/Find an identifier
;		Created:	11th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Create/Find an identifier YX
; 									  CC = Found, CS = Created
;
; ************************************************************************************************

AXICreateFind:
		stx 	AXTemp1 					; save address at zTemp1
		sty 	AXTemp1+1
		jsr 	AXICalculateHash 			; calculate hash
		;
		lda 	AXIBase 					; start scanning.
		sta 	AXTemp0+1
		stz 	AXTemp0
		jsr 	AXIOpen 					; start.
		;
		;		Find the end, checking for duplicates as we go.
		;
_AXIFindEnd:								; go to the end checking for duplicates.		
		lda 	(AXTemp0)
		beq 	_AXIFoundEnd
		jsr 	AXICompareCurrent 			; compare AXTemp1 ident vs AXTemp0 record
		bcc 	_AXICFound 					; it's been found.
		;
		clc 								; go to next
		lda 	(AXTemp0)
		adc 	AXTemp0
		sta 	AXTemp0
		bcc 	_AXIFindEnd
		inc 	AXTemp0+1
		bra 	_AXIFindEnd
		;
		;		AXTemp0 now points at the end (the zero link)
		;
_AXIFoundEnd:
		ldy 	#0 
		;
_AXIFill:									; fill +2,3,4,5 with zeros.		
		lda 	#0		
		sta 	(AXTemp0),y
		iny
		cpy 	#AXID_Identifier
		bne 	_AXIFill
_AXICopy:
		phy
		tya 								; access equivalent character in name.
		sec
		sbc 	#AXID_Identifier
		tay
		lda 	(AXTemp1),y 				; get character and write it out.
		ply
		sta 	(AXTemp0),y
		iny 								; next character
		asl 	a 							; keep going till bit 7 set.
		bcc 	_AXICopy

		lda 	#0 							; write zero at end (end of list)
		sta 	(AXTemp0),y 		
		;
		tya 								; set the offset link.
		sta 	(AXTemp0)
		;
		ldy 	#AXID_Hash 					; fill the data in. +1 is the hash
		lda 	AXIHash
		sta 	(AXTemp0),y
		;
		ldy 	#AXID_Flags 				; set the undefined flag.
		lda 	#$80
		sta 	(AXTemp0),y
		sec 								; return CS, created
		;		
_AXICFound:
		php 								; save carry
		lda 	AXTemp0 					; save as current record
		sta 	AXCurrent
		lda 	AXTemp0+1
		sta 	AXCurrent+1
		jsr 	AXIClose 					; close access
		plp 								; restore carry.
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

