; ************************************************************************************************
; ************************************************************************************************
;
;		Name : 		apifile.asm
;		Purpose :	API Open/Read/Close
;		Date :		20th August 2023
; 		Reviewed :	No
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;											Open a file
;
; ************************************************************************************************

TAOpen:
		lda 	#_FileNameEnd-_FileName
		ldx 	#<_FileName
		ldy 	#>_FileName
		jsr 	$FFBD 						; SETNAM

		lda 	#15
		ldx 	#8
		ldy 	#0
		jsr 	$FFBA 						; set LFS

		jsr 	$FFC0 						; OPEN, returns CS on failure.
		lda 	#15
_TAOExit:		
		rts

_FileName:
		.text 	'CODE.ASM'
_FileNameEnd:

; ************************************************************************************************
;
;										Close file handle in X
;
; ************************************************************************************************

TAClose:
		txa							; CLOSE
		jsr 	$FFC3
		clc
		rts		

; ************************************************************************************************
;
;								Read a character from the input stream X.
;
; ************************************************************************************************

TAReadChar:
		jsr 	$FFC6  						; CHKIN
		jsr 	$FFC6 
		jsr 	$FFCF 						; CHRIN
		pha
		jsr 	$FFB7 						; READST
		and 	#64
		clc
		beq 	_TARExit
		sec
_TARExit:		
		php
		jsr 	$FFCC  						; CLRCHN
		plp	
		pla
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
