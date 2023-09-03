* = $8000

m11 	.macro
_loop
		lda 	#42
		jsr 	$FFD2
		bra 	_loop
		.endm

		m11 42,3
		m11 43,4