; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		assemble.asm
;		Purpose:	Assemble a line from the source
;		Created:	12th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;				Assemble line in buffer. Returns CS on error, error code in A.
;
; ************************************************************************************************

AXAssembleLine:
		ldx 	#0 							; start of line
_AXAContinue:		
		jsr 	AXGet 						; get first character
		clc 								; if 0, empty line, exit with carry clear
		beq 	_AXExit

		; ========================================================================================
		;
		;				Two options , it's * = <xxxx> or a label/instruction
		;
		; ========================================================================================

		cmp 	#'*' 						; is it * (for * = )
		beq 	_AXSetPC
		;
		jsr 	AXExtractIdentifier 		; get an identifier	
		bcs 	_AXSyntax 					; if none found, report it as a syntax error.

		; ========================================================================================
		;
		;							Check if it's a mnemonic
		;
		; ========================================================================================

		phx 								; look in system dictionary (opcodes, pseudo ops etc).
		ldx 	#SystemDictionary & $FF
		ldy 	#SystemDictionary >> 8
		jsr 	AXIFind
		plx
		bcs 	_AXALabel 					; not found, label check.
		.byte 	$DB
		jmp 	$FFFF
		
		; ========================================================================================
		;
		;					Not a mnemonic, so it's a label of some sort.
		;
		; ========================================================================================

_AXALabel:
		phx
		ldy 	AXIBase 					; start scanning.
		ldx 	#0
		jsr 	AXICreateFind 				; find it, or create it if necessary.
		plx

		jsr 	AXProcessLabel 				; process the label.
		bcc 	_AXAContinue 				; if okay, try the line again.
		rts 								; return with error.

		; ========================================================================================
		;
		;								Set the PC (* = <expr>)
		;
		; ========================================================================================
_AXSetPC:
		inx 	 							; get next.
		jsr 	AXGet
		cmp 	#'=' 						; must be equals.
		bne 	_AXSyntax
		inx
		jsr 	AXExpressionDefined 		; get an expression, must be defined.
		bcs 	_AXExit 					; error of some sort.

		lda 	AXLeft 						; copy result to current PC
		sta 	AXProgramCounter
		lda 	AXLeft+1
		sta 	AXProgramCounter+1
		clc 								; and done successfully.
		rts

_AXSyntax:
		lda 	#AXERRSyntax
		sec
_AXExit:		
		rts		

; ************************************************************************************************
;
;			Label (e.g. unknown identifier) in buffer. Decide what to do with it
;
; ************************************************************************************************

AXProcessLabel:		
		jsr 	AXGet 						; what is next
		beq 	_AXLabelPC 					; nothing, it's a program counter label
		cmp 	#':'						; if label: then it's a program counter label.
		beq 	_AXPCTR 					; (we have to consume the :)
		jsr 	AXIsIdentifierHead 			; some identifier follows.
		bcc 	_AXLabelPC 					; then it's a program counter label.
		;
		inx 								; consume it anyway.
		cmp 	#'=' 						; must be '=' something
		beq 	_AXAssignValue 				; yes, assign value
		;
		lda 	#AXERRSyntax 				; otherwise syntax error
		sec
_AXPExit:		
		rts

		; ========================================================================================
		;
		;				It's a label PC e.g. <label> <command> or <label>:
		;
		; ========================================================================================

_AXPCTR:
		inx 								; consume :
_AXLabelPC:
		phx 								; save position
		ldx 	AXProgramCounter
		ldy 	AXProgramCounter+1
		jsr 	AXIPutData 					; write it.
		plx 								; restore position
		rts 								; return with that error code.

		; ========================================================================================
		;
		;							It's label = <expression>
		;
		; ========================================================================================

_AXAssignValue:
		lda 	AXCurrent 					; save current identifier
		pha
		lda 	AXCurrent+1
		pha

		jsr 	AXExpressionDefined 		; evaluate expression

		pla 								; restore current identifier.
		sta 	AXCurrent+1
		pla
		sta 	AXCurrent

		bcs 	_AXPExit 					; exit on error.

		phx
		ldx 	AXLeft 						; set to the result
		ldy 	AXLeft+1 					; preserving X
		jsr 	AXIPutData
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

