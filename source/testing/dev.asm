* = $8000

textpr  .macro
		ldx 	#_textmsg & $FF
		ldy 	#_textmsg >> 8
		jsr 	$FFFC
		bra 	_continue
_textmsg:
		.text 	\1,0
_continue		
		.endm

		textpr "Hello"

