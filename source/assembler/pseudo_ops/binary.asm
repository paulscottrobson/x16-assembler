; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		binary.asm
;		Purpose:	.binary command
;		Created:	23rd August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Include a binary file
;
; ************************************************************************************************

AXBInclude:	;; {.binary}
AXBInclude2:;; {.incbin}

		ldx 	AXOperandPos		
		jsr		AXTGetTextString 			; file name to buffeer
		bcs 	_AXISyntax 					; failed.
		;
		jsr 	AXListLine 					; list line before expansion
		jsr 	AXPushFrame 				; save current frame 	

		lda 	#AXAPIOpen 					; open the source file.
		ldy 	#AXTextParameter >> 8
		ldx 	#AXTextParameter & $FF
		jsr 	AXCallAPI 
		sta 	AXFileHandle 				; save handle
		lda 	#AXERRNotFound 				; return not found if failed.
		bcs 	_AXBExit

_AXBOut:
		lda 	#AXAPIReadByte 				; read char using API
		ldx 	AXFileHandle
		jsr 	AXCallAPI
		bcs 	_AXBEndFile 				; exit on EOF
		jsr 	AXWriteByte 				; otherwise copy out.
		bra 	_AXBOut
_AXBEndFile
		lda 	#AXAPIClose 				; close the file.
		ldx 	AXFileHandle
		jsr 	AXCallAPI
		;
		jsr 	AXPullFrame 				; restore frame saving the results 
		stz 	AXBuffer 					; stop 2nd listing.	
		clc
_AXBExit:		
		rts

_AXISyntax:
		lda 	#AXERRSyntax
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

