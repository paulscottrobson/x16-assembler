; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       insert.asm
;       Purpose:    Insert parameter from previous frame in current buffer
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;       Insert parameter A (0-n-1, one short) at position X in buffer. Parameter is obtained
;       from the *previous frame*
;
; ************************************************************************************************

AXIInsertParameter: 
        stx     AXIPPosition                ; save position & index
        sta     AXIPIndex   
        jsr     AXIOpen                     ; start.

        lda     AXIStack                    ; AXTemp0 points to previous frame.
        sta     AXTemp0
        lda     AXIStack+1
        sta     AXTemp0+1

        lda     AXIPIndex                   ; get the count of parameters
        ldy     #(AXMParamCount-AXStartFrame)
        lda     AXIPIndex                   ; compare index vs count
        cmp     (AXTemp0),y
        bcs     _AXIPError                  ; parameter error
        ;
        clc                                 ; point into parameter array 
        adc     #(AXMParameters-AXStartFrame)
        tay
        lda     (AXTemp0),y                 ; copy start and end offset
        sta     AXIPStart
        iny
        lda     (AXTemp0),y
        sta     AXIPEnd
        ;
        ldx     AXIPPosition                ; move to end to check size and insert spaces.
_AXIPFindEnd:
        inx
        lda     AXBuffer,x
        bne     _AXIPFindEnd
        ;
        sec                                 ; to position add length to insert
        txa                                 ; (end-start)
        adc     AXIPEnd
        sbc     AXIPStart
        cmp     #AXMaxLineSize              ; line is too long ?
        bcs     _AXIPError
        ;
        tay                                 ; now shift it up to make room.
_AXIPShiftUp:
        lda     AXBuffer,x
        sta     AXBuffer,y
        cpx     AXIPPosition
        beq     _AXIPShifted
        dex
        dey
        bra     _AXIPShiftUp                
_AXIPShifted:
        ;
        ldy     AXIPStart                   ; copy parameter data in place.
_AXIPCopy:
        lda     (AXTemp0),y
        sta     AXBuffer,x
        inx
        iny
        cpy     AXIPEnd
        bne     _AXIPCopy
        clc                                 ; and successful.
        bra     _AXIPExit

_AXIPError:
        lda     #AXERRParam                 ; return bad parameter.
        sec
_AXIPExit:                                  ; exit preserving AP through close.
        php
        pha
        jsr     AXIClose                    ; close access
        pla
        plp
        rts


        .send as16code

        .section as16storage
AXIPPosition:                               ; position in buffer
        .fill   1
AXIPIndex:                                  ; index-1 (e.g. \1 => 0)
        .fill   1
AXIPStart:                                  ; start position        
        .fill   1
AXIPEnd:                                    ; end position.     
        .fill   1
        .send as16storage


