; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		file.asm
;		Purpose:	Assemble a single file
;		Created:	12th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Assemble file, YX is file name/NULL
;
; ************************************************************************************************

AXAssembleFile:
		lda 	#AXAPIOpen 					; open the source file.
		jsr 	AXCallAPI 
		sta 	AXFileHandle 				; save handle
		lda 	#AXERRNotFound 				; return not found if failed.
		bcs 	_AXAFExit
		;
		stz 	AXLastCharacter 			; no last character
		stz 	AXLineNumber 				; reset line numbers
		stz 	AXLineNumberDecimal	
		stz 	AXLineNumber+1 
		stz 	AXLineNumberDecimal+1
		;
		stz 	AXLocalLabelID 				; reset the local label ID
		stz 	AXLocalLabelID+1
		;
		;		The main assembler loop.
		;
_AXMainLoop:
		;
		jsr 	AXReadLine 					; read the next line
		bcs 	_AXAFError 					; exit if problem (e.g. too long/eof)

		jsr 	AXAssembleLine 				; assemble it.
		bcs 	_AXAFError 					; exit if problem there.		

		jsr 	AXListLine 					; list the line.
		bra 	_AXMainLoop
		;
		;		Come here on error *or* EOF
		;
_AXAFError:
		cmp 	#AXERREOF 					; was the error EOF, which isn't an error :)
		clc 								; if so don't report an error.
		beq 	_AFAXCloseExit
		
		sta 	AXErrorCode 				; save errorcode
		ldy 	#AXErrorCode >> 8 			; YX = error area.
		ldx 	#AXErrorCode & $FF
		lda 	#AXAPIError 				
		jsr 	AXCallAPI 			 		; returns CS if always exit.
		lda 	AXErrorCode 				; if error code is fatal, e.g. bit 7 set
		bpl 	_AFAXCloseExit
		sec 								; you cannot override it.
		
_AFAXCloseExit:
		php 								; save error flag and error ID
		pha
		lda 	#AXAPIClose 				; close the file.
		ldx 	AXFileHandle
		jsr 	AXCallAPI
		pla 								; restore flag/id and exit.
		plp
_AXAFExit:
		rts		

; ************************************************************************************************
;
;										Call the API function
;
; ************************************************************************************************

AXCallAPI:
		jmp 	(AXAPI)

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

