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
		cpx 	#0 							; check default name ?
		bne 	_TAHaveName
		cpy 	#0
		bne 	_TAHaveName

		ldx 	#<_FileName 				; use default.
		ldy 	#>_FileName
		lda 	#7 							; reset handle tracker
		sta 	TAHandleTracker
_TAHaveName:
		stx 	TATemp0 					; get length
		sty 	TATemp0+1
		ldy 	#255
_TAGetLen:
		iny
		lda 	(TATemp0),y
		bne 	_TAGetLen
		tya 								; A = size, XY = filename
		ldy 	TATemp0+1
		jsr 	$FFBD 						; SETNAM

		inc 	TAHandleTracker
		lda 	TAHandleTracker
		pha
		ldx 	#8
		ldy 	#0
		jsr 	$FFBA 						; set LFS

		jsr 	$FFC0 						; OPEN, returns CS on failure.
		pla
_TAOExit:			
		rts

_FileName:
		.text 	'CODE.ASM',0

; ************************************************************************************************
;
;										Close file handle in X
;
; ************************************************************************************************

TAClose:
		txa
		jsr 	$FFC3
		dec 	TAHandleTracker
		clc
		rts		

; ************************************************************************************************
;
;								Read a character from the input stream X.
;
; ************************************************************************************************

TAReadChar:
		jsr 	$FFC6  						; CHKIN
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

		.section as16zeropage
TATemp0:
		.fill 	2
		.send as16zeropage

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

