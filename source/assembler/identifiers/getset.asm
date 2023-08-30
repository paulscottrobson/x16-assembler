; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		getset.asm
;		Purpose:	Access offset data.
;		Created:	11th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Get element Y => A
;
; ************************************************************************************************

AXIGet:	
		jsr 	AXIOpen 					; start.

		lda 	AXCurrent 					; copy address for access
		sta 	AXTemp0
		lda 	AXCurrent+1
		sta 	AXTemp0+1

		lda 	(AXTemp0),y 				; read
		jsr 	AXIClose 					; close access

		rts

; ************************************************************************************************
;
;									Set element Y to A
;
; ************************************************************************************************

AXIPut:	
		jsr 	AXIOpen 					; start.
		pha
		lda 	AXCurrent 					; copy address for access
		sta 	AXTemp0
		lda 	AXCurrent+1
		sta 	AXTemp0+1
		pla
		sta 	(AXTemp0),y 				; write
		jsr 	AXIClose 					; close access
		rts

; ************************************************************************************************
;
;								Put Data YX to DataLow/High, and set flag
;
;				  Put can *FAIL* if defined and different - a redefinition error.
;
; ************************************************************************************************

AXIPutData:	
		jsr 	AXIOpen 					; start.
		lda 	AXCurrent 					; copy address for access
		sta 	AXTemp0
		lda 	AXCurrent+1
		sta 	AXTemp0+1

		phy 								; save Y on stack.
		ldy 	#AXID_Flags
		lda 	(AXTemp0),y 				; check if defined.
		bmi 	_AXIPutOkay 				; no, it is always okay to put.

		pla  								; get MSB back
		pha
		ldy 	#AXID_DataHigh
		cmp 	(AXTemp0),y
		bne 	_AXIPutError 				; if value has changed, that's an error
		txa 								; check LSB
		ldy 	#AXID_DataLow
		cmp 	(AXTemp0),y
		bne 	_AXIPutError 				; if value has changed, that's an error

_AXIPutOkay:
		pla
		ldy 	#AXID_DataHigh 				; write high byte
		sta 	(AXTemp0),y 			

		txa
		ldy 	#AXID_DataLow 				; write low byte
		sta 	(AXTemp0),y 			

		ldy 	#AXID_Flags 				; clear the 'defined' flag.
		lda 	(AXTemp0),y
		and 	#$7F
		sta 	(AXTemp0),y

		jsr 	AXIClose 					; close access
		clc
		rts

_AXIPutError:
		pla 								; throw saved Y
		jsr 	AXIClose 					; return with error redefine.
		lda 	#AXERRRedefine
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

