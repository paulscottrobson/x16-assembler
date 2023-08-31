; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		getdata.asm
;		Purpose:	Get address of associated data / Get line.
;		Created:	31st August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;										Get data address to YX
;
; ************************************************************************************************

AXIGetDataAddress:	
		jsr 	AXIOpen 					; start.

		lda 	AXCurrent 					; copy address for access
		sta 	AXTemp0
		lda 	AXCurrent+1
		sta 	AXTemp0+1

		ldy 	#AXID_Identifier 			; point to name
_AXIFindEnd: 								; find end of name.
		lda 	(AXTemp0),y 				; get next
		asl 	a		 					; bit 7 to carry
		iny
		bcc 	_AXIFindEnd
		;
		tya 								; put address of data in YX.
		clc
		adc 	AXTemp0
		tax
		lda 	AXTemp0+1
		adc 	#0
		tay

		jsr 	AXIClose 					; close access
		rts

; ************************************************************************************************
;
;				Get line from AXMPointer to AXBuffer, CS if EOData, CC if okay
;
; ************************************************************************************************

AXIGetDataLine:
		lda 	AXMPointer 					; copy pointer to AXTemp0
		sta 	AXTemp0
		lda 	AXMPointer+1
		sta 	AXTemp0+1
		lda 	(AXTemp0) 					; reached the end ?
		cmp 	#$FF
		sec 								; if so exit with CS.
		beq 	_AXIExit
		;
		ldy 	#0 							; copy data line to buffer.
_AXIGDLCopy:
		lda 	(AXTemp0),y
		sta 	AXBuffer,y
		iny
		cmp 	#0
		bne 	_AXIGDLCopy
		;
		tya 								; Y is step to next line.
		clc		
		adc 	AXMPointer
		sta 	AXMPointer
		bcc 	_AXIExitOkay
		inc 	AXMPointer+1
_AXIExitOkay:
		clc 								; is okay.
_AXIExit:
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

