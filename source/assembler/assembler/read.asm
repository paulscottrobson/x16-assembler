; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		read.asm
;		Purpose:	Read a line from the source
;		Created:	12th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;								Read line from file into buffer
;
; ************************************************************************************************

AXReadLine:
		stz 	AXInQuotes 					; ' " flag reset
		ldx 	#0 							; read from line start
		jsr 	AXReadCharacter 			; try to read one.
		bcs		_AXRLExit 					; failed		
		;
		;		Read a character successfully
		;
_AXRLLoop:
		cmp 	#13 						; read EOL ? then exit.
		beq 	_AXRLEndLine
		;
		;		Have character, decide what to do with it - CR,capitalise, quoted, length check etc.
		;
		ldy 	AXInQuotes 					; are we in quote mode
		bne 	_AXInQuotes
		;
		cmp 	#";"						; no, exit if reached comment
		beq 	_AXRLConsumeLine
		jsr 	AXConvertUpper 				; capitalise it.
		cmp 	#'"'						; check entering quotes
		beq 	_AXEnterQuotes
		cmp 	#"'"
		bne 	_AXOutChar 					; write otherwise
		;
		;		Found ' " entering quotes
		;
_AXEnterQuotes:		
		sta 	AXInQuotes 					; entering quotes
		bra 	_AXOutChar
		;
		;		Consume the rest of the line to CR/EOF
		;
_AXRLConsumeLine:
		jsr 	AXReadCharacter
		bcs 	_AXRLEndLine
		cmp 	#13
		bne 	_AXRLConsumeLine
		bra 	_AXRLEndLine		
		;
		;		In quotes, exit if matching found.
		;
_AXInQuotes:
		cmp 	AXInQuotes 					; leaving quotes, e.g. matching '" found.
		bne 	_AXOutChar 					; no, just output normally.
		stz 	AXInQuotes 					; reset the in quotes flag.
_AXOutChar:
		sta 	AXBuffer,x 				
		inx
		jsr 	AXReadCharacter 			; read next
		bcc 	_AXRLLoop	 				; loop back if not EOF
		;
		;		End of line make ASCIIZ
		;
_AXRLEndLine:
		stz 	AXBuffer,x 					; make buffer ASCIIZ.
		clc
_AXRLExit:		
		rts		

		.send as16code

		.section as16storage
AXInQuotes:
		.fill 	1
		.send as16storage

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

