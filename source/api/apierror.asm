; ************************************************************************************************
; ************************************************************************************************
;
;		Name : 		apierror.asm
;		Purpose :	API Error Handler
;		Date :		24th August 2023
; 		Reviewed :	No
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;					Handle Error, YX is address of error information
;
; ************************************************************************************************

TAError:
		stx 	TATemp0 					; save info area address
		sty 	TATemp0+1
		lda 	#'*'						; print 3 stars
		jsr 	AXListOut
		jsr 	AXListOut
		jsr 	AXListOut
		lda 	(TATemp0) 					; output error code
		jsr 	AXLOutHex
		lda 	#'@' 						; output @
		jsr 	AXListOut
		ldy 	#4 						 	; output the page number (4+5 are BCD)
		lda 	(TATemp0),y
		jsr 	AXLOutHex
		dey
		lda 	(TATemp0),y
		jsr 	AXLOutHex
		lda 	#13 						; new line.
		jsr 	AXListOut
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

