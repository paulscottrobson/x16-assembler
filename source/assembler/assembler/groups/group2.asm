; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       group2.asm
;       Purpose:    Assemble group 2 (ldx, asl and similar)
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Assemble group 2 instruction
;
; ************************************************************************************************

AXGroup2:
        jsr     AXIdentifyAddressMode       ; get the address mode
        bcs     _AXG2Exit                   ; syntax error.

        jsr     AXGroup2Assemble            ; assemble group2
        bcc     _AXG2Exit                   ; it worked.
        jsr     AXPromoteMode               ; promote mode.
        bcs     _AXG2Exit                   ; failed to promote.
        jsr     AXGroup2Assemble            ; try it with absolute mode.

_AXG2Exit:      
        rts

; ************************************************************************************************
;
;       Try to assemble with current mode. If ZP check range. CS if failed, CC if succeeded.
;                               (should return error on STA #)
;
;       Also test against the Fixup table which contains all the oddities.
;
; ************************************************************************************************

AXGroup2Assemble:
        lda     AXAddrMode                  ; get the address mode
        and     #$1F                        ; if >= 8 will be in the oddballs table
        cmp     #8 
        bcs     _AX2CheckFixupList
        tax                                 
        lda     AXSelector                  ; bit pattern showing what is supported, what isn't.
_AXG2CheckSelector:                         ; shift the mode enabled bit into the carry
        asl     a
        dex
        bpl     _AXG2CheckSelector      
        bcc     _AX2CheckFixupList          ; not supported.
        ;
        lda     AXAddrMode                  ; if it is not zero page, then it's okay.
        bpl     _AX2IsOkay

        lda     AXPass                      ; for immediate check pass 2 only.
        cmp     #2                          ; (see group 1)
        beq     _AX2CheckSize
        lda     AXAddrMode
        cmp     #AXMImmediate
        beq     _AX2IsOkay

_AX2CheckSize:
        lda     AXLeft+1                    ; okay if zero page, and < 256
        bne     _AX2Fail
_AX2IsOkay:
        lda     AXAddrMode                  ; mode x 4
        and     #$1F
        asl     a
        asl     a
        adc     AXBaseOpcode
        jsr     AXWriteByte                 ; write out the opcode.
        jsr     AXWriteOperand              ; write the operand appropriately,
        clc
        rts
        ;
        ;       Didn't work. Let's try this mode and base opcode against ehf dix up list.
        ;
_AX2CheckFixupList:
        lda     AXAddrMode                  ; fail if zero page address mode and non-zp operand.
        bpl     _AX2CheckFixup
        lda     AXLeft+1
        bne     _AX2Fail
_AX2CheckFixup:             
        ldx     #0
_AX2FixupLoop:
        lda     AXGroup2OpcodeFixupTable,x  ; base opcode
        beq     _AX2Fail
        cmp     AXBaseOpcode                ; if opcodes dont match go to next.
        bne     _AX2Next
        lda     AXGroup2OpcodeFixupTable+1,x; address mode
        cmp     AXAddrMode
        beq     _AX2Found                   ; found a match
_AX2Next:       
        inx                                 ; next table entry
        inx
        inx
        bra     _AX2FixupLoop
        ;
_AX2Found:
        lda     AXGroup2OpcodeFixupTable+2,x ; get actual opcode
        jsr     AXWriteByte     
        jsr     AXWriteOperand              ; write the operand appropriately,
        clc
        rts

_AX2Fail:
        lda     #AXERRMode                  ; bad mode error.
        sec
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

