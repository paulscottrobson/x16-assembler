; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       group4.asm
;       Purpose:    Assemble group 4 instruction (without operands)
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Assemble group 4 instruction
;
; ************************************************************************************************

AXGroup4:
        lda     AXBaseOpcode                ; just assemble the base opcode.
        jsr     AXWriteByte
        clc
        rts

        .send as16code
        

