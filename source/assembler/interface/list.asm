; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		list.asm
;		Purpose:	Output listing for current pass
;		Created:	13th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Output listing current line.
;
; ************************************************************************************************

AXListLine:
		lda 	AXProgramCounterStart+2 	; Page
		jsr 	AXLOutHex
		lda 	#58
		jsr 	AXListOut
		lda 	AXProgramCounterStart+1 	; Address
		jsr 	AXLOutHex
		lda 	AXProgramCounterStart+0 	
		jsr 	AXLOutHex


		jsr 	AXLSpace
		ldx 	#0 							; output the line.
_AXOutLine:
		lda 	AXBuffer,x
		beq 	_AXEnd
		jsr 	AXConvertUpper
		jsr 	AXListOut
		inx
		bra 	_AXOutLine
_AXEnd:		
		lda 	#13 						; CR/LF
		jsr 	AXListOut
		rts

; ************************************************************************************************
;
;											Output A in Hex
;
; ************************************************************************************************

AXLOutHex: 								
		pha 								; do upper nibble
		lsr 	a
		lsr 	a
		lsr 	a
		lsr 	a
		jsr 	_AXLOutNibble
		pla 								; do lower nibble
_AXLOutNibble:	
		and 	#15
		cmp 	#10
		bcc 	_AXLNotHex
		adc 	#6
_AXLNotHex:
		adc 	#48
		jmp 	AXListOut				

; ************************************************************************************************
;
;										Call the API function
;
; ************************************************************************************************

AXLSpace:
		lda 	#32
AXListOut:
		phx 								; preserve XY and call API List function.
		phy	
		tax
		lda 	#6
		jsr 	AXCallAPI
		ply
		plx
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

