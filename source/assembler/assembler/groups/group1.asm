; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		group1.asm
;		Purpose:	Assemble group 1 (lda,sta,adc,cmp,sbc,and,eor,ora)
;		Created:	17th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Assemble group 1 instruction
;
; ************************************************************************************************

AXGroup1:
		jsr 	AXIdentifyAddressMode 		; get the address mode
		bcs 	_AXG1Exit 		 			; syntax error.
		jsr 	AXGroup1Assemble 			; assemble group 1 with ZP/# mods.
		bcc 	_AXG1Exit 					; it worked.
		jsr 	AXPromoteMode 				; promote mode.
		bcs 	_AXG1Exit 					; failed
		jsr 	AXGroup1Assemble 			; try it with absolute mode.
_AXG1Exit:		
		rts

; ************************************************************************************************
;
;		Try to assemble with current mode. If ZP check range. CS if failed, CC if succeeded.
;								(should return error on STA #)
;
;		Note, the initial 8 modes are slightly different for the Group 1 set, see spreadsheet.
;
; ************************************************************************************************

AXGroup1Assemble:
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

