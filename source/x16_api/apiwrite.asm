; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      apiwrite.asm
;       Purpose :   Write assembled byte 
;       Date :      11th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Handle byte assembly/save/storage.
;
; ************************************************************************************************

TAWriteByte:
        tya                                 ; simple save
        sta     ($00,x)

        rts

        phy                                 ; dump code to screen, not used really but an option.
        lda     #'@'                        ; or you could write it to a file.
        jsr     AXListOut
        lda     $02,x
        jsr     AXLOutHex
        lda     #'.'
        jsr     AXListOut
        lda     $01,x
        jsr     AXLOutHex
        lda     $00,x
        jsr     AXLOutHex
        lda     #"="
        jsr     AXListOut
        pla
        jsr     AXLOutHex
        lda     #13
        jsr     AXListOut
        rts

        .send as16code


