; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		getdata.asm
;		Purpose:	Get address of associated data
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
		tay

		jsr 	AXIClose 					; close access
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

