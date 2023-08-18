; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		errors.inc
;		Purpose:	Error codes
;		Created:	9th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;										Error codes
;
; ************************************************************************************************

AXERREOF = $00 								; end of file, not assembler error.
AXERRSyntax = $01 							; general syntax error.
AXERRIdentifier = $02 						; bad identifier, missing/too long.
AXERRDivZero = $03 							; divide by zero.
AXERRRedefine = $04 						; value of an identifier has changed.
AXERRNotFound = $05 						; source file not found.
AXERRUndefined = $06 						; undefined identifier.
AXERRRelative = $07 						; relative branch range.
AXERRMode = $08 							; address mode not supported in 65C02

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

