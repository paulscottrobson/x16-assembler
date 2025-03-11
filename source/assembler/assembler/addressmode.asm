; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       addressmode.asm
;       Purpose:    Identify the address mode/operand for the post opcode part of the instruction.
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                   Work out the address mode from X , store in AXAddrMode
;                          CC if okay, CS if error with error in A.
;                            Expressions evaluated as per pass 2.
;
; ************************************************************************************************

AXIdentifyAddressMode:

        ; ----------------------------------------------------------------------------------------
        ;
        ;                           First check for ASL/ASL A
        ;
        ; ----------------------------------------------------------------------------------------

        jsr     AXGet                       ; has two formats, ASL and ASL A
        cmp     #0
        beq     _AXIsAccumulator
        cmp     #'A'
        bne     _AXCheckImmediate

        lda     AXBuffer+1,x                ; is the A followed by space/eol
        cmp     #' '+1
        bcs     _AXCheckImmediate
_AXIsAccumulator:
        lda     #AXMAccumulator     
        sta     AXAddrMode
_AXIsOkay:      
        clc
_AXExit:        
        rts

        ; ----------------------------------------------------------------------------------------
        ;
        ;                           Check for Immediate and Indirect
        ;
        ; ----------------------------------------------------------------------------------------

_AXCheckImmediate:      
        cmp     #'#'                        ; immediate
        beq     _AXIsImmediate
        cmp     #'('                        ; indirect
        beq     _AXIsIndirect
        ;
        ; ----------------------------------------------------------------------------------------
        ;
        ;                               nnnn nnnn,x or nnnn,y
        ;
        ; ----------------------------------------------------------------------------------------

        jsr     AXPass2Expression           ; evaluate base address
        bcs     _AXExit                     ; error in that.
        jsr     AXGet                       ; what follows
        beq     _AXIsDirect                 ; nothing, nnnn
        cmp     #','                        ; if not needs to be ,X ,Y
        bne     _AXSyntax
        inx
        jsr     AXGet                       ; what follows should be X or Y
        tay
        lda     #AXMZeroX                   ; check for ,X ,Y
        cpy     #"X"
        beq     _AXExitOkay
        lda     #AXMZeroY
        cpy     #"Y"
        beq     _AXExitOkay
        ;
_AXSyntax: 
        lda     #AXERRSyntax
        sec
        rts

_AXIsDirect:
        lda     #AXMZero 
_AXExitOkay:        
        sta     AXAddrMode
        clc
        rts

        ; ----------------------------------------------------------------------------------------
        ;
        ;                                           Immediate
        ;
        ; ----------------------------------------------------------------------------------------

_AXIsImmediate:
        inx                                 ; consume the #
        jsr     AXPass2Expression           ; get operand
        bcs     _AXExit                     ; bad operand

        lda     #AXMImmediate               ; return immediate
        sta     AXAddrMode
        clc
        rts

        ; ----------------------------------------------------------------------------------------
        ;
        ;                           indirect (nnnn) (nnnn,x) or (nnnn),y
        ;
        ; ----------------------------------------------------------------------------------------

_AXIsIndirect:      
        inx
        jsr     AXPass2Expression           ; the address to indirect through
        jsr     AXGet                       ; what follows.
        cmp     #","                        ; if , then check for indirect X
        beq     _AXIndirectX
        cmp     #")"                        ; otherwise must be closing bracket
        bne     _AXSyntax
        inx                                 ; consume )

        ; ----------------------------------------------------------------------------------------
        ;
        ;                       indirect (nnnn) or indirect y (nnnn),y
        ;
        ; ----------------------------------------------------------------------------------------

        jsr     AXGet                       ; if nothing follows it is (xxx)
        beq     _AXIndirect 
        cmp     #","                        ; otherwise must be ,Y
        bne     _AXSyntax
        inx
        jsr     AXGet
        cmp     #"Y"
        bne     _AXSyntax
        ;
        lda     #AXMIndirectY               ; indirect Y
        sta     AXAddrMode
        clc
        rts

_AXIndirect:                                ; indirect
        lda     #AXMIndirect
        sta     AXAddrMode
        clc
        rts     

        ; ----------------------------------------------------------------------------------------
        ;
        ;                               Indirect X (nnnn,x)
        ;
        ; ----------------------------------------------------------------------------------------

_AXIndirectX:
        inx                                 ; consume comma

        jsr     AXGet                       ; check x
        cmp     #"X"
        bne     _AXSyntax

        inx     
        jsr     AXGet                       ; check )
        cmp     #")"
        bne     _AXSyntax

        lda     #AXMIndirectX               ; it's indirect X
        sta     AXAddrMode
        clc
        rts

        .send as16code
        
        .section as16storage
AXAddrMode:
        .fill   1
        .send as16storage


