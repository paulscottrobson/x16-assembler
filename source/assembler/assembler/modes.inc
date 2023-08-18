; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		modes.inc
;		Purpose:	Address modes
;		Created:	17th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;										Address modes.
;
;	Bits 0..5 represent 4 steps in bytes from 00.07 for Group2 . Group 1 is slightly different.
;	Bit 7 set if zero page address required.
;
; ************************************************************************************************

AXMRequireZero = $80

AXMImmediate = 			$00 + AXMRequireZero 	; lda #$2A
AXMZero = 				$01 + AXMRequireZero 	; lda $2A
AXMAccumulator =		$02  					; inc OR inc A
AXMAbsolute = 			$03 					; lda $2ABC
AXMIndirectY =			$04 + AXMRequireZero 	; lda ($2A),y
AXMZeroX =				$05 + AXMRequireZero 	; lda $2A,x
AXMAbsoluteY = 			$06 					; lda $2ABC,y
AXMAbsoluteX = 			$07 					; lda $2ABC,x
AXMIndirect =			$08 + AXMRequireZero 	; lda ($2A)
AXMZeroY =				$09 + AXMRequireZero 	; lda $2A,y
AXMAbsoluteIndirect = 	$0A 					; jmp ($2ABC)
AXMAbsoluteIndirectX = 	$0B 					; jmp ($2ABC,x)
AXMRelative = 			$0C 					; bra $2A (not used)
AXMIndirectX = 			$0D + AXMRequireZero 	; lda ($2A,x)

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
