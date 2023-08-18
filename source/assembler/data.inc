; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		data.inc
;		Purpose:	Assembler main data
;		Created:	9th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;										Zero Page
;
; ************************************************************************************************

		.section as16zeropage

AXTemp0: 									; 3 bytes as it is used for the API output function.
		.fill 	3

		.send 	as16zeropage


; ************************************************************************************************
;
;										Constants
;
; ************************************************************************************************

		.section as16storage

AXMaxLineSize = 80
AXMaxIdentSize = 16
AXListByteCount = 4

; ************************************************************************************************
;
;										Global Data
;
; ************************************************************************************************

AXLeft:										; left and right evaluation
		.fill 	3 							; the bytes are LSB, MSB, undefined flag (bit 7)
AXRight:
		.fill 	3

AXProgramCounter:							; program counter / bank
		.fill 	3 	

AXEvaluatePage: 							; page # of last evaluated label.
		.fill 	1

AXLabelBuffer: 								; buffer for label to be evaluated (ASCIIZ, U/C)
		.fill 	AXMaxIdentSize+1

AXCurrent:									; address of currently selected identifier.
		.fill 	2

AXAPI:  									; API call address.
		.fill 	2		

AXPass:										; pass (1 or 2)
		.fill 	1		
		
; ************************************************************************************************
;
;					Frame data - this is saved when macro recursion occurs
;
; ************************************************************************************************

AXStartFrame:

AXFileHandle:	 							; file handle			
		.fill 	1
AXLastCharacter:							; last character read.
		.fill 	1

AXLineNumber: 								; line number.
		.fill 	2				
AXLineNumberDecimal: 						; line number in decimal.
		.fill 	2

AXProgramCounterStart: 						; PCTR at instruction start.
		.fill 	3

AXBuffer:	 								; current line, ASCIIZ.
		.fill 	AXMaxLineSize+1 						

AXListCount: 								; byte count in list buffer
		.fill 	1
AXListBytes: 								; those bytes
		.fill 	AXListByteCount

AXEndFrame:

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

