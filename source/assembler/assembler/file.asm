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
		lda 	#1 							; open the source file.
		jsr 	AXCallAPI 
		sta 	AXFileHandle 				; save handle
		lda 	#AXERRNotFound 				; return not found if failed.
		bcs 	_AXAFExit
		;
		stz 	AXLastCharacter 			; no last character
		lda 	#1 							; set line number to 1
		sta 	AXLineNumber 		
		stz 	AXLineNumber+1 
		;
		;		The main assembler loop.
		;
_AXMainLoop:
		lda 	AXProgramCounter 			; copy program counter to program counter start
		sta 	AXProgramCounterStart 		; this is the value used in the unary function *
		lda 	AXProgramCounter+1
		sta 	AXProgramCounterStart+1
		lda 	AXProgramCounter+2
		sta 	AXProgramCounterStart+2
		;
		jsr 	AXReadLine 					; read the next line
		bcs 	_AXAFError 					; exit if problem (e.g. too long/eof)

		jsr 	AXAssembleLine 				; assemble it.
		bcs 	_AXAFError 					; exit if problem there.		

		jsr 	AXListLine 					; list the line.
		
		inc 	AXLineNumber 				; bump line number
		bne 	_AXMainLoop
		inc 	AXLineNumber+1
		bra 	_AXMainLoop

		;
		;		Come here on error *or* EOF
		;
_AXAFError:
		cmp 	#AXERREOF 					; was the error EOF, which isn't an error :)
		sec 								; if not, still report an error
		bne 	_AFAXCloseExit
		clc 								; if EOF, end of file, it's okay.

_AFAXCloseExit:
		php 								; save error flag and error ID
		pha
		lda 	#2 							; close the file.
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

