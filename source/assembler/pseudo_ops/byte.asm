; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       byte.asm
;       Purpose:    .byte command
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Assemble .byte command
;
; ************************************************************************************************

AXByteCmd:  ;; {.byte}
AXByteCmd2: ;; {.db}

        ldx     AXOperandPos                ; get operand, must be defined even on pass 1.

_AXBLoop:
        jsr     AXPass2Expression           ; get value
        bcs     _AXBExit

        lda     AXPass                      ; only check size on pass 2
        cmp     #2
        bne     _AXBNoCheck

        lda     AXLeft+1
        beq     _AXBNoCheck

        lda     #AXERRSize                  ; not a byte.
        sec
        rts

_AXBNoCheck:
        lda     AXLeft                      ; output the byte.
        jsr     AXWriteByte

        jsr     AXGet                       ; get next
        inx
        cmp     #","
        beq     _AXBLoop
        cmp     #0
        bne     _AXBSyntax
        clc
        rts
_AXBSyntax:
        lda     #AXERRSyntax
        sec
_AXBExit:       
        rts


        .send as16code
        

