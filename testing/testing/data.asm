; *******************************************************************************************
;
;							Test assembly of data pseudocode
;
; *******************************************************************************************

		* = $8000

		.byte 	0,255,$1A,'*'
label:		
		.word 	$FEDC,32766,0,42
		.word  	label
		.text 	42,"Hello world !",13,0

		rts