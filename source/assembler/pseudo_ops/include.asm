; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		include.asm
;		Purpose:	.include command
;		Created:	22nd August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Include a file
;
; ************************************************************************************************

AXInclude:	;; {.include}

		ldx 	AXOperandPos		
		jsr		AXTGetTextString 			; file name to buffeer
		bcs 	_AXISyntax 					; failed.
		;
		jsr 	AXListLine 					; list line before expansion
		jsr 	AXPushFrame 				; save current frame 	

		ldy 	#AXTextParameter >> 8 		; assemble named file
		ldx 	#AXTextParameter & $FF 
		jsr 	AXAssembleFile

		php 								; restore frame saving the results 
		pha
		jsr 	AXPullFrame
		stz 	AXBuffer 					; stop 2nd listing.	
		pla
		plp
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

