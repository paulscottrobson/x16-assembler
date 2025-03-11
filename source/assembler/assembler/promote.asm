; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       promote.asm
;       Purpose:    Promotes current address mode to absolute.
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;       Promote current address mode to absolute from zero page, return CS if not possibl
;
; ************************************************************************************************

axpromote .macro
        ldx     #\2
        cmp     #\1
        beq     AXDoPromote
        .endm

AXPromoteMode:
        lda     AXAddrMode
        .axpromote  AXMZero,AXMAbsolute
        .axpromote  AXMZeroX,AXMAbsoluteX
        .axpromote  AXMZeroY,AXMAbsoluteY
        .axpromote  AXMIndirect,AXMAbsoluteIndirect
        .axpromote  AXMIndirectX,AXMAbsoluteIndirectX
        sec
        rts
AXDoPromote:
        stx     AXAddrMode      
        clc
        rts

        .send as16code
        

