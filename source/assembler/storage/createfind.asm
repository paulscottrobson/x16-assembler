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
;									Create/Find an identifier in YX
; 									  CC = Found, CS = Created
;
; ************************************************************************************************

AXICreateFind:
		jsr 	AXIFind 					; find it ?
		bcc 	_AXFound 					; found so do nothing
		jsr 	AXICreate 					; create new record
		sec 								
_AXFound:
		rts

; ************************************************************************************************
;
;									   Find an identifier in YX
; 				CC = Found, AXTemp0 points to it CS = Not Found, AXTemp0 points to end
;
; ************************************************************************************************

AXIFind:
		stx 	AXTemp0 					; save address at zTemp0
		sty 	AXTemp0+1
		jsr 	AXICalculateHash 			; calculate hash
		;
		jsr 	AXIOpen 					; start.
		;
		;		Find the end, checking for duplicates as we go.
		;
_AXIFindEnd:								; go to the end checking for duplicates.		
		lda 	(AXTemp0)
		sec
		beq 	_AXIFindExit
		jsr 	AXICompareCurrent 			; compare AXTemp1 ident vs AXTemp0 record
		bcc 	_AXIFoundExit 				; it's been found.
		;
		clc 								; go to next
		lda 	(AXTemp0)
		adc 	AXTemp0
		sta 	AXTemp0
		bcc 	_AXIFindEnd
		inc 	AXTemp0+1
		bra 	_AXIFindEnd

_AXIFoundExit:
		jsr 	AXISetCurrent
		clc

_AXIFindExit:		
		php
		jsr 	AXIClose
		plp
		rts

; ************************************************************************************************
;
;								Create identifier if not found
;
; ************************************************************************************************

AXICreate:	
		clc 								; check memory short ?
		lda 	AXTemp0+1
		adc 	#2
		cmp 	AXIStack+1
		bcc 	_AXINoMemory
		dec 	AXIMemory 					; set memory flag.
_AXINoMemory:		

		jsr 	AXIOpen 					; start.
		ldy 	#0 
		;
_AXIFill:									; fill +2,3,4,5 with zeros.		
		lda 	#0		
		sta 	(AXTemp0),y
		iny
		cpy 	#AXID_Identifier
		bne 	_AXIFill
_AXICopy:
		lda 	AXLabelBuffer-AXID_Identifier,y 	; copy name in from buffer.
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
		jsr 	AXISetCurrent
		jsr 	AXIClose 					; close access
		plp 								; restore carry.
		rts

AXISetCurrent:
		lda 	AXTemp0 					; save as current record
		sta 	AXCurrent
		lda 	AXTemp0+1
		sta 	AXCurrent+1
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

