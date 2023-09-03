* = $8000

m11 	.macro
		lda 	#\1
		jsr 	$FFD2
		.endm

		m11 42,3
		m11 43,4