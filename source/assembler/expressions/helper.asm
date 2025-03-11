; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       helper.asm
;       Purpose:    Expression helpers
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;               Evaluate expression at Buffer,X. Undefined identifiers => error.
;
;         Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;
; ************************************************************************************************

AXExpressionDefined:
        jsr     AXExpression                ; evaluate
        bcs     _AXDExit                    ; some other error.
        lda     AXLeft+2                    ; check defined.
        bpl     _AXDExit                    ; okay.

        sec                                 ; return undefined error
        lda     #AXERRUndefined
_AXDExit:
        rts

; ************************************************************************************************
;
;           Evaluate expression at Buffer,X. Undefined identifiers => error on pass2 
;
;         Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;                           On error, the default value is set to $EEEE
;
; ************************************************************************************************

AXPass2Expression:
        jsr     AXExpression                ; evaluate
        bcs     _AXDExit                    ; some other error.
        lda     AXLeft+2                    ; check defined.
        bpl     _AXDExit                    ; okay.

        lda     #$EE                        ; set the default value to $EEEE
        sta     AXLeft
        sta     AXLeft+1

        lda     AXPass                      ; if pass 1, that's okay even if undefined.
        cmp     #1
        clc
        beq     _AXDExit
    
        sec                                 ; return undefined error
        lda     #AXERRUndefined
_AXDExit:
        rts
                
        .send as16code

; ************************************************************************************************
;
;                                   Changes and Updates
;
; ************************************************************************************************
;
;       Date            Notes
;       ====            =====
;
; ************************************************************************************************
