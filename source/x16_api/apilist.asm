; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      apilist.asm
;       Purpose :   API List Handler
;       Date :      11th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Handle listing, character in X
;
; ************************************************************************************************

TAListChar:
        txa
        .if TESTING==2
        jsr     $FFD2                       ; this is only displayed for TESTING=2
        .endif
        rts

        .send as16code


