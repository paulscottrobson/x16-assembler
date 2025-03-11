; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       extract.asm
;       Purpose:    Extract an identifier.
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                           Extract Identifier at X to LabelBuffer
;
; ************************************************************************************************

AXExtractIdentifier:    
        lda     AXBuffer,x                  ; check the first character.
        jsr     AXIsIdentifierHead
        bcs     _AXELFail
        ;
        ldy     #0                          ; save position.
        lda     AXBuffer,x                  ; is the first character a _
        cmp     #"_"                        ; if so, we need to make it a local
        bne     _AXELLoop
        pha
        phx                                 ; local header into labelbuffer
        jsr     AXILocalHeader
        plx
        pla
        ;
_AXELLoop:      
        sta     AXLabelBuffer,y             ; save in buffer, bump position
        iny
        cpy     #AXMaxIdentSize+1           ; too long
        beq     _AXELFail
        inx                                 ; consume character
        lda     #0                          ; make ASCIIZ.
        sta     AXLabelBuffer,y
        ;
        lda     AXBuffer,x                  ; get the next caracter.
        jsr     AXIsIdentifierBody          ; is it a body character
        bcc     _AXELLoop                   ; if so add it to the label.
        ;
        lda     AXLabelBuffer-1,y           ; set bit 7 of last character.
        ora     #$80
        sta     AXLabelBuffer-1,y
        ;
        clc                                 ; successfully acquired a label.
        rts

_AXELFail:
        lda     #AXERRIdentifier            ; bad label.
        sec
        rts

; ************************************************************************************************
;
;                       New local label set, encountered on global label
;
; ************************************************************************************************

AXIBumpLocal:
        sed
        clc
        lda     AXLocalLabelID
        adc     #1
        sta     AXLocalLabelID
        lda     AXLocalLabelID+1
        adc     #0
        sta     AXLocalLabelID+1
        cld     
        rts

; ************************************************************************************************
;
;                                   Make a local label unique
;
; ************************************************************************************************

AXILocalHeader:
        lda     #"_"
        sta     AXLabelBuffer,y
        iny
        lda     AXLocalLabelID+1
        jsr     _AXILHOut
        lda     AXLocalLabelID
_AXILHOut:
        pha
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        jsr     _AXILNOut
        pla
_AXILNOut:
        and     #15
        ora     #48
        sta     AXLabelBuffer,y
        iny
        rts     

        .send as16code


