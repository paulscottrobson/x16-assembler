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
;									Get element Y => A
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
; ************************************************************************************************

AXIPutData:	
		jsr 	AXIOpen 					; start.
		lda 	AXCurrent 					; copy address for access
		sta 	AXTemp0
		lda 	AXCurrent+1
		sta 	AXTemp0+1

		tya
		ldy 	#AXID_DataHigh 				; write high byte
		sta 	(AXTemp0),y 			

		txa
		ldy 	#AXID_DataLow 				; write low byte
		sta 	(AXTemp0),y 			

		ldy 	#AXID_Flags 				; set the 'defined' flag.
		lda 	(AXTemp0),y
		ora 	#$80
		sta 	(AXTemp0),y

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

