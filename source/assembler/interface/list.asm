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
		lda 	AXPass 						; only on pass 2
		cmp 	#2
		bne 	_AXLLExit

		lda 	AXBuffer 					; blank line ?
		beq 	_AXLLExit
		
		lda 	AXLineNumberDecimal+1
		jsr 	AXLOutHex
		lda 	AXLineNumberDecimal
		jsr 	AXLOutHex
		jsr	 	AXLSpace
		
		lda 	AXProgramCounterStart+2 	; Page
		jsr 	AXLOutHex
		lda 	#58
		jsr 	AXListOut
		lda 	AXProgramCounterStart+1 	; Address
		jsr 	AXLOutHex
		lda 	AXProgramCounterStart+0 	
		jsr 	AXLOutHex
		jsr 	AXLSpace
		ldx 	#0 							; output listing bytes
_AXLHex:
		jsr 	AXLSpace 					; space
		cpx 	AXListCount 				; compare against done.
		bcs 	_AXLSpace 					; if <= done then output spaces.
		lda 	AXListBytes,x 	
		jsr 	AXLOutHex 					; output hex 
		bra 	_AXLLLoop
_AXLSpace:
		jsr 	AXLSpace
		jsr 	AXLSpace
_AXLLLoop:		
		inx
		cpx	 	#AXListByteCount 			; done all of them
		bne 	_AXLHex
		;
		jsr 	AXLSpace 					; another space.
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
_AXLLExit:		
		rts

; ************************************************************************************************
;
;				Store first listing bytes for display (first 4 at present)
;
; ************************************************************************************************

AXAddListingByte:
		ldx 	AXListCount 				; already max listable
		cpx 	#AXListByteCount
		beq 	_AXAExit
		sta 	AXListBytes,x 				; store the byte
		inc 	AXListCount 				; bump count

_AXAExit:		
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
		lda 	#AXAPIListChar
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

