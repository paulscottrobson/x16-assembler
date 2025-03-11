; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       input.asm
;       Purpose:    Read a character from the input
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                       Read next character, CS on error. Always returns CR for EOL.
;
; ************************************************************************************************

AXReadCharacter:
        phx
        phy
        lda     AXLastCharacter             ; is last character $FF, this means EOF
        cmp     #$FF
        beq     _AXREOF
        ;
_AXNext:        
        lda     #3                          ; read char using API
        ldx     AXFileHandle
        jsr     AXCallAPI
        bcs     _AXREOF
        ;
        cmp     #9                          ; convert TAB to space
        bne     _AXRNotSpace
        lda     #' '
_AXRNotSpace:
        cmp     #10                         ; if not LF, exit successfully.
        bne     _AXRExit                    
        ldx     AXLastCharacter             ; check last char was CR
        cpx     #13
        beq     _AXNext                     ; if so its CR/LF so we ignore the LF.
        sta     AXLastCharacter
        lda     #13                         ; return CR, last char still LF.
        bra     _AXRExit2
_AXRExit:
        sta     AXLastCharacter
_AXRExit2:      
        clc
        ply
        plx
        rts

_AXREOF:
        lda     #$FF
        sta     AXLastCharacter
        sec
        ply
        plx
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

