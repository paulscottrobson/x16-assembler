; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		utility.asm
;		Purpose:	Identifier utility functions
;		Created:	11th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;		Compare current checked (text at AXTemp1, hash in AXHash) with record AXTemp0
;								CC if match, CS if no match.
;
; ************************************************************************************************

AXICompareCurrent:
		ldy 	#1 							; check the hashes match.
		lda 	(AXTemp0),y
		cmp 	AXIHash
		bne 	_AXICCFail 					; they don't, fail.
		;
		ldy 	#0 							; compare offset 6.
_AXICCLoop:
		phy
		lda 	(AXTemp1),y 				; character from buffer
		pha 								; save it.
		tya 								; point into equivalent place in record +6
		clc
		adc 	#6
		tay		
		pla 								; get character back
		eor 	(AXTemp0),y 				; compare against record entry.
		ply 								; restore Y 
		cmp 	#0 							; if the compare failed then exit
		bne 	_AXICCFail  				
		;
		lda 	(AXTemp1),y  				; get the buffer character
		iny 								; consume it
		asl 	a 							; if it's bit 7 was clear, go back.
		bcc 	_AXICCLoop
		clc 								; matched !
		rts

_AXICCFail:
		sec
		rts

; ************************************************************************************************
;
;						Calculate hash at AXTemp1 return in A/AXIHash
;
; ************************************************************************************************

AXICalculateHash:
		stz 	AXIHash 					; clear hash
		ldy 	#0
_AXICHLoop:
		clc 								; add character, saving it
		lda 	(AXTemp1),y
		iny
		pha
		adc 	AXIHash
		sta 	AXIHash
		pla 								; loop back if +ve
		bpl 	_AXICHLoop
		lda 	AXIHash 					; return value.
		rts

		.send as16code

		.section as16storage
AXIHash:
		.fill 	1
		.endsection

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

