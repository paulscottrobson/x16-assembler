; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       assemble.asm
;       Purpose:    Assemble a line from the source
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;               Assemble line in buffer. Returns CS on error, error code in A.
;
; ************************************************************************************************

AXAssembleLine:
        lda     AXIMemory                   ; out of memory ?
        beq     _AXALMemOkay
        lda     #AXERRMemory                ; if so, report it.
        sec
        rts
_AXALMemOkay:       
        lda     AXProgramCounter            ; copy program counter to program counter start
        sta     AXProgramCounterStart       ; this is the value used in the unary function *
        lda     AXProgramCounter+1
        sta     AXProgramCounterStart+1
        lda     AXProgramCounter+2
        sta     AXProgramCounterStart+2

        stz     AXListCount                 ; clear the listing bytes.
        ldx     #0                          ; start of line
_AXAContinue:       
        jsr     AXGet                       ; get first character
        cmp     #0
        bne     _AXHasText
        clc                                 ; if 0, empty line, exit with carry clear
        rts

        ; ========================================================================================
        ;
        ;               Two options , it's * = <xxxx> or a label/instruction
        ;
        ; ========================================================================================

_AXHasText:
        cmp     #'*'                        ; is it * (for * = )
        beq     _AXSetPC
        ;
        jsr     AXExtractIdentifier         ; get an identifier 
        bcs     _AXSyntax                   ; if none found, report it as a syntax error.

        ; ========================================================================================
        ;
        ;                   Check if it's a system word, if so, process that.
        ;
        ; ========================================================================================

        phx                                 ; look in system dictionary (opcodes, pseudo ops etc).
        ldx     #AXSystemDictionary & $FF
        ldy     #AXSystemDictionary >> 8
        jsr     AXIFind
        plx
        bcs     _AXALabel                   ; not found, label check.
        ;
        phx
        ldy     #AXID_Type                  ; get the type
        jsr     AXIGet
        plx
        ;
        cmp     #AXIT_Opcode                ; different code for opcode, macro, pseudo-op.
        beq     _AXAOpcode
        cmp     #AXIT_Macro
        beq     _AXAMacro
        cmp     #AXIT_PsuedoOp
        bne     _AXSyntax
        ;
        ; ========================================================================================
        ;
        ;                               Handle pseudo-operations
        ;
        ; ========================================================================================

        stx     AXOperandPos                ; save the operand position.
        ldy     #AXID_DataLow               ; get the code address and jump there.
        jsr     AXIGet
        sta     AXVector
        ldy     #AXID_DataHigh
        jsr     AXIGet
        sta     AXVector+1
        jmp     (AXVector)
        ;
        jmp     $FFFF                       ; load the address and jump to it.
_AXAMacro:
        jmp     AXPAssembleMacro
_AXAOpcode:
        jmp     AXPAssembleOpcode   

        ; ========================================================================================
        ;
        ;                   Not a mnemonic, so it's a label of some sort.
        ;
        ; ========================================================================================

_AXALabel:
        phx
        ldy     AXIBase                     ; start scanning.
        ldx     #0
        jsr     AXICreateFind               ; find it, or create it if necessary.

        plx
        jsr     AXGet                       ; if followed by '.' cannot be macro invocation
        cmp     #"."
        beq     _AXANotMacro
        phx
        
        ldy     #AXID_Type                  ; get the type.
        jsr     AXIGet
        plx

        cmp     #AXIT_Macro                 ; if macro, go to macro code.
        beq     _AXAMacro

_AXANotMacro:
        jsr     AXProcessLabel              ; process the label.
        bcc     _AXAContinue                ; if okay, try the line again.
        rts                                 ; return with error.

        ; ========================================================================================
        ;
        ;                               Set the PC (* = <expr>)
        ;
        ; ========================================================================================
_AXSetPC:
        inx                                 ; get next.
        jsr     AXGet
        cmp     #'='                        ; must be equals.
        bne     _AXSyntax
        inx
        jsr     AXExpressionDefined         ; get an expression, must be defined.
        bcs     _AXExit                     ; error of some sort.

        lda     AXLeft                      ; copy result to current PC
        sta     AXProgramCounter
        lda     AXLeft+1
        sta     AXProgramCounter+1
        clc                                 ; and done successfully.
        rts

_AXSyntax:
        lda     #AXERRSyntax
        sec
_AXExit:        
        rts     

; ************************************************************************************************
;
;           Label (e.g. unknown identifier) in buffer. Decide what to do with it
;
; ************************************************************************************************

AXProcessLabel:     
        lda     AXPass                      ; don't set the type on pass 2
        cmp     #2
        beq     _AXPLNoSet
        phx                                 ; set type to label/identifiier.
        lda     #AXIT_Label
        ldy     #AXID_Type
        jsr     AXIPut
        plx
_AXPLNoSet:     

        jsr     AXGet                       ; what is next
        beq     _AXLabelPC                  ; nothing, it's a program counter label
        cmp     #':'                        ; if label: then it's a program counter label.
        beq     _AXPCTR                     ; (we have to consume the :)
        jsr     AXIsIdentifierHead          ; some identifier follows.
        bcc     _AXLabelPC                  ; then it's a program counter label.
        ;
        inx                                 ; consume it anyway.
        cmp     #'='                        ; must be '=' something
        beq     _AXAssignValue              ; yes, assign value
        ;
        lda     #AXERRSyntax                ; otherwise syntax error
        sec
_AXPExit:       
        rts

        ; ========================================================================================
        ;
        ;               It's a label PC e.g. <label> <command> or <label>:
        ;
        ; ========================================================================================

_AXPCTR:
        inx                                 ; consume :
_AXLabelPC:
        phx                                 ; save position
        ldx     AXProgramCounter
        ldy     AXProgramCounter+1
        jsr     AXIPutData                  ; write it.
        bcs     _AXRedefine
        ;
        lda     AXProgramCounter+2          ; write the bank
        ldy     #AXID_DataAux
        jsr     AXIPut

        lda     AXLabelBuffer               ; is it a non local label ?
        cmp     #"_"
        beq     _AXNotGlobal
        jsr     AXIBumpLocal                ; we need new locals.
_AXNotGlobal:       
        plx                                 ; restore position
        clc
        rts                                 ; return with that error code.

_AXRedefine:                                ; redefined so probably out of sync.
        plx
        sec
        rts

        ; ========================================================================================
        ;
        ;                           It's label = <expression>
        ;
        ; ========================================================================================

_AXAssignValue:
        lda     AXCurrent                   ; save current identifier
        pha
        lda     AXCurrent+1
        pha

        jsr     AXExpressionDefined         ; evaluate expression

        pla                                 ; restore current identifier.
        sta     AXCurrent+1
        pla
        sta     AXCurrent

        bcs     _AXPExit                    ; exit on error.

        phx
        ldx     AXLeft                      ; set to the result
        ldy     AXLeft+1                    ; preserving X
        jsr     AXIPutData
        plx
        rts

        .send as16code

        .section as16storage
AXOperandPos:                               ; data in buffer starts here.
        .fill   1       
AXVector:                                   ; for calling psuedo op code
        .fill   2
        .send as16storage
        
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

