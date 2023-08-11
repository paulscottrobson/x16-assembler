; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		extract.asm
;		Purpose:	Extract an identifier.
;		Created:	9th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;							Extract Identifier at X to LabelBuffer
;
; ************************************************************************************************

AXExtractIdentifier:	
		lda 	AXBuffer,x 					; check the first character.
		jsr 	AXIsIdentifierHead
		bcs 	_AXELFail
		ldy 	#0 							; save position.
		;
_AXELLoop:		
		sta 	AXLabelBuffer,y 			; save in buffer, bump position
		iny
		cpy 	#AXMaxIdentSize+1 			; too long
		beq 	_AXELFail
		inx 								; consume character
		lda 	#0 							; make ASCIIZ.
		sta 	AXLabelBuffer,y
		;
		lda 	AXBuffer,x 					; get the next caracter.
		jsr 	AXIsIdentifierBody 			; is it a body character
		bcc 	_AXELLoop 					; if so add it to the label.
		;
		lda 	AXLabelBuffer-1,y 			; set bit 7 of last character.
		ora 	#$80
		sta 	AXLabelBuffer-1,y
		;
		clc 								; successfully acquired a label.
		rts

_AXELFail:
		lda 	#AXERRIdentifier			; bad label.
		sec
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

