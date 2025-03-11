; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       write.asm
;       Purpose:    Write byte A
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                       Write byte A
;
; ************************************************************************************************

AXWriteByte:
        pha                                 ; save registers
        phx
        phy

        pha                                 ; add to listing
        jsr     AXAddListingByte
        pla

        ldx     AXPass                      ; output pass#2 only.
        cpx     #2
        bne     _AXWBBumpPC

        ldx     AXProgramCounter            ; copy location
        stx     AXTemp0
        ldx     AXProgramCounter+1
        stx     AXTemp0+1
        ldx     AXProgramCounter+2
        stx     AXTemp0+2

        tay                                 ; char to Y.
        ldx     #AXTemp0                    ; ($00,X) is the address
        lda     #AXAPIWriteByte             ; API function 4
        jsr     AXCallAPI
        ;
_AXWBBumpPC:        
        inc     AXProgramCounter            ; bump PC
        bne     _AXWBSkip
        inc     AXProgramCounter+1
_AXWBSkip:      
        ply
        plx
        pla
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

