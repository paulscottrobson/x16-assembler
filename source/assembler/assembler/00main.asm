; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       00main.asm
;       Purpose:    Entry point.
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                   Assemble code : API at YX
;
; ************************************************************************************************

AXAssemble:
        stx     AXAPI                       ; save the API.
        sty     AXAPI+1
        jsr     AXIReset                    ; reset the identifier system.

        lda     #1
        jsr     AXAssemblerPass
        bcs     _AXAExit
        lda     #2
        jsr     AXAssemblerPass
_AXAExit:       
        rts
        
; ************************************************************************************************
;
;                                           Do Pass A
;
; ************************************************************************************************


AXAssemblerPass:
        sta     AXPass                      ; set the pass

        stz     AXProgramCounter            ; zero the program counter + bank
        stz     AXProgramCounter+1
        stz     AXProgramCounter+2

        ldx     #0                          ; assemble the default file.
        ldy     #0
        jsr     AXAssembleFile
        rts

        .send as16code



