; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       frames.asm
;       Purpose:    Push/Pull frame off stack
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                   Push frame on stack
;
; ************************************************************************************************

AXPushFrame:    
        jsr     AXIOpen
        sec                                 ; subtract frame size from stack, copy to AXTemp0
        lda     AXIStack
        sbc     #AXFrameSize
        sta     AXIStack
        sta     AXTemp0
        lda     AXIStack+1
        sbc     #0
        sta     AXIStack+1
        sta     AXTemp0+1
        ;
        ldy     #AXFrameSize                ; copy frame to stack space.
_AXPFCopy:
        dey
        lda     AXStartFrame,y
        sta     (AXTemp0),y
        cpy     #0
        bne     _AXPFCopy       
        jsr     AXIClose
        rts

; ************************************************************************************************
;
;                                   Pull frame off stack
;
; ************************************************************************************************

AXPullFrame:    
        jsr     AXIOpen
        clc                                 ; add frame size to stack, copy to AXTemp0
        lda     AXIStack
        sta     AXTemp0
        adc     #AXFrameSize
        sta     AXIStack

        lda     AXIStack+1
        sta     AXTemp0+1
        adc     #0
        sta     AXIStack+1
        ;
        ldy     #AXFrameSize                ; copy frame from stack space.
_AXPFCopy:
        dey
        lda     (AXTemp0),y
        sta     AXStartFrame,y
        cpy     #0
        bne     _AXPFCopy       
        jsr     AXIClose
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

