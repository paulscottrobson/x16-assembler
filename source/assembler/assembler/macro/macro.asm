; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		macro.asm
;		Purpose:	Assemble a macro
;		Created:	14th August 2023
;		Reviewed:	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section as16code

; ************************************************************************************************
;
;									Assemble a macro, parameters from X.
;
; ************************************************************************************************

AXPAssembleMacro:
		jsr 	AXMAnalyseParameters		; work out the parameters limits.
		bcs 	_AXPAMExit 					; error (probably too many parameters)

		.byte 	$DB	
		; start from beginning of code in macro

		jsr 	AXPushFrame 				; save current frame 	

		; for each line
		; 		get line from macro storage
		; 		perform substitutions until all done
		; 		assemble line

		jsr 	AXPullFrame
		clc
_AXPAMExit:
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

