; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       group1.asm
;       Purpose:    Assemble group 1 (lda,sta,adc,cmp,sbc,and,eor,ora)
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Assemble group 1 instruction
;
; ************************************************************************************************

AXGroup1:
        jsr     AXIdentifyAddressMode       ; get the address mode
        bcs     _AXG1Exit                   ; syntax error.

        jsr     AXGroup1Assemble            ; assemble group 1 with ZP/# mods.
        bcc     _AXG1Exit                   ; it worked.
        jsr     AXPromoteMode               ; promote mode.
        bcs     _AXG1Exit                   ; failed to promote.
        jsr     AXGroup1Assemble            ; try it with absolute mode.

_AXG1Exit:      
x       rts

; ************************************************************************************************
;
;       Try to assemble with current mode. If ZP check range. CS if failed, CC if succeeded.
;                               (should return error on STA #)
;
;       Note, the initial 8 modes are slightly different for the Group 1 set, see spreadsheet.
;
; ************************************************************************************************

AXGroup1Assemble:
        lda     AXAddrMode                  ; get address mode
        cmp     #AXMIndirectX               ; we support indirect X
        beq     _AXG1ModeOk
        cmp     #AXMIndirect                ; and indirect
        beq     _AXG1ModeOk
        ;
        cmp     #AXMAccumulator             ; A is not supported.
        beq     _AXG1Fail                   ; other than that, just 0-7.                    
        and     #$1F
        cmp     #8
        bcs     _AXG1Fail
        ;
_AXG1ModeOk:        
        lda     AXAddrMode                  ; does the mode support 3 byte.
        bpl     _AXGOperandOk               ; if so, we can't reject for being ZP.

        lda     AXPass                      ; on pass 1, allow immediate always.
        cmp     #2  
        beq     _AXGCheckSize
        lda     AXAddrMode
        cmp     #AXMImmediate
        beq     _AXGOperandOk

_AXGCheckSize:
        lda     AXLeft+1                    ; fail if not a zero page operand.
        bne     _AXG1Fail
_AXGOperandOk:

        lda     AXAddrMode                  ; map (nn,x) onto 0 and # onto 2 because
        tax                                 ; group 1 is structured slightly differently.
        cpx     #AXMImmediate
        bne     _AXGNotImmediate
        lda     #2
_AXGNotImmediate:
        cpx     #AXMIndirectX       
        bne     _AXGNotIX
        lda     #0
_AXGNotIX:
        cpx     #AXMIndirect
        bne     _AXGNotIndirect
        clc                                 ; indirect, add $11 to opcode
        lda     #$11
        bra     _AXGAddOpcode

_AXGNotIndirect:
        and     #$1F                        ; now a 0-7 address mode, x 4 and add the base opcode
        asl     a
        asl     a
_AXGAddOpcode:      
        adc     AXBaseOpcode
        cmp     #$89                        ; cannot sta #
        beq     _AXG1Fail
        jsr     AXWriteByte                 ; write out the opcode.
        jsr     AXWriteOperand              ; write the operand appropriately
        clc
        rts

_AXG1Fail:
        lda     #AXERRMode                  ; bad mode error.
        sec
        rts

; ************************************************************************************************
;
;                       Write operand in AXLeft according to AXAddrMode
;
; ************************************************************************************************

AXWriteOperand:
        lda     AXAddrMode                  ; if Accumulator mode exit
        cmp     #AXMAccumulator
        beq     _AXWIs2Byte
                
        lda     AXLeft                      ; output LSB
        jsr     AXWriteByte
        lda     AXAddrMode
        bmi     _AXWIs2Byte
        lda     AXLeft+1                    ; output MSB if wanted.
        jsr     AXWriteByte
_AXWIs2Byte:        
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

