		* = $8000		
		nop
;		lda 	#<textmsg 
;		ldx 	#<textmsg 
		jsr 	Printstring
textmsg:


Printstring:
