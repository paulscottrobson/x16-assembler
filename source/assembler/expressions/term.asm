; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       term.asm
;       Purpose:    Evaluate term.
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Evaluate term at Buffer,X.
;
;         Return CS on error, A is error code. CC if successful. Result goes into AXLeft
;
;       Terms can be :  decimal $hexadecimal %binary
;                       'x' character code.
;                       - negation 
;                       * program counter at start of instruction.
;                       label.address @label.page
;                       <lower.byte >upper.byte
;                       (expression)
;
; ************************************************************************************************

AXTerm: jsr     AXGet
        ;
        stz     AXLeft+2                    ; clear the undefined flag & value
        stz     AXLeft
        stz     AXLeft+1
        ;
        lda     AXBuffer,x                  ; get first character
        ldy     #10                         ; default decimal if digit
        jsr     AXIsNumeric                 ; if digit numeric , then constant.
        bcc     _AXIsConstant
        ; 
        inx                                 ; temporarily consume base modifier
        ldy     #16                         ; hex check.
        cmp     #"$"
        beq     _AXIsConstant
        ldy     #2                          ; binary check
        cmp     #"%"
        bne     _AXNotConstant

; ================================================================================================
;
;                               Constant at buffer,X. Base is in Y.
;
; ================================================================================================

_AXIsConstant:      
        stz     AXDigitCount                ; clear count of digits
        sty     AXBase                      ; save base.
_AXConstantLoop:
        lda     AXBuffer,x                  ; get the next character of the constant.       
        jsr     AXIsAlphaNumeric            ; must be 0-9A-Z
        bcs     _AXConstantDone             ; no, then end of constant.
        ;
        cmp     #"9"+1                      ; shift A-Z so they follow 0-9.
        bcc     _AXNotAlpha
        sbc     #7
_AXNotAlpha:
        sec                                 ; make it a digit 0..15
        sbc     #"0"        
        cmp     AXBase                      ; if higher than the base, then end of constant
        bcs     _AXConstantDone
        ;
        inx                                 ; consume as legal.
        inc     AXDigitCount                ; bump consumed count.
        pha                                 ; save the new digit.
        jsr     _AXMultiplyBase             ; multiply left by base.
        pla                                 ; add new digit
        clc
        adc     AXLeft
        sta     AXLeft
        bcc     _AXConstantLoop
        inc     AXLeft+1
        bra     _AXConstantLoop
        ;
        ;       Reached an invalid constant.
        ;
_AXConstantDone:
        clc
        lda     AXDigitCount                ; exit okay if a digit received
        bne     _AXCExit
        sec                                 ; return error-syntax
        lda     #AXERRSyntax 
_AXCExit:
        rts     

; ================================================================================================
;
;                                   Parenthesis expression
;
; ================================================================================================

_AXParenthesis:
        jsr     AXExpression                ; body of parenthesis expression.
        bcs     _AXPExit                    ; error ?
_AXFindParent:
        jsr     AXGet                       ; next non-space
        inx                                 ; consume
        cmp     #')'
        clc
        beq     _AXPExit
        lda     #AXERRSyntax                ; failed
        sec
_AXPExit:
        rts

; ================================================================================================
;
;       Handle non constants. Not $x %x or decimal. First character in A, already consumed.
;       
; ================================================================================================

_AXNotConstant:
        cmp     #"-"                        ; check for negation.
        beq     _AXNegate
        cmp     #"<"                        ; low byte
        beq     _AXLowByte
        cmp     #">"                        ; high byte
        beq     _AXHighByte
        cmp     #"*"                        ; start of instruction
        beq     _AXProgramCounter
        cmp     #"'"                        ; character code
        beq     _AXCharacter        
        cmp     #"@"                        ; label page
        beq     _AXLabelPage
        cmp     #"("                        ; parenthesis
        beq     _AXParenthesis
        jsr     AXIsIdentifierHead          ; identifier start character
        bcs     _AXCFail
        dex                                 ; back to first character.
        jsr     AXEvaluateLabel             ; consume and evaluate a label.
        rts                                 

; ================================================================================================
;
;                                       Character code.
;
; ================================================================================================

_AXCharacter:
        lda     AXBuffer,x                  ; get the character code.
        beq     _AXCFail                    ; can't be EOS.
        sta     AXLeft
        lda     AXBuffer+1,x                ; get the character after and consume both
        inx
        inx
        cmp     #"'"                        ; okay if '
        clc
        beq     _AXNExit
_AXCFail:                                   ; fail with syntax error.
        sec
        lda     #AXERRSyntax
        rts 

; ================================================================================================
;
;                                       Label page @label
;   
; ================================================================================================

_AXLabelPage:       
        jsr     AXEvaluateLabel             ; consume and evaluate a label.
        bcs     _AXLPExit                   ; something failed, probably no label.
        lda     AXEvaluatePage              ; copy page #
        sta     AXLeft
        stz     AXLeft+1
        clc
_AXLPExit:
        rts     

; ================================================================================================
;
;                                     PC at instruction start
;
; ================================================================================================

_AXProgramCounter:
        lda     AXProgramCounterStart
        sta     AXLeft      
        lda     AXProgramCounterStart+1
        sta     AXLeft+1
        clc
        rts

; ================================================================================================
;
;                       High low byte (processing does not affect carry)
;
; ================================================================================================

_AXHighByte:
        jsr     AXTerm
        bcs     _AXNExit
        lda     AXLeft+1
        sta     AXLeft
        stz     AXLeft+1        
        rts
        ;
_AXLowByte:
        jsr     AXTerm
        bcs     _AXNExit
        stz     AXLeft+1
        rts

; ================================================================================================
;
;                                       Negate
;
; ================================================================================================

_AXNegate:
        jsr     AXTerm                      ; get term
        bcs     _AXNExit
        sec
        lda     #0
        sbc     AXLeft
        sta     AXLeft
        lda     #0
        sbc     AXLeft+1
        sta     AXLeft+1
        clc                                 ; success.
_AXNExit:       
        rts

; ================================================================================================
;
;                   Multiply the AXLeft value by the base (supports 2,10,16)
;
; ================================================================================================

_AXMultiplyBase:
        cpy     #2                          ; if binary then exit.
        beq     _AXMDouble
        cpy     #16                         ; if hexadecimal
        beq     _AXMMultiply16
        ;
        lda     AXLeft+1                    ; keep original value.
        pha
        lda     AXLeft 
        jsr     _AXMDouble                  ; x 2
        jsr     _AXMDouble                  ; x 4       
        clc
        adc     AXLeft                      ; add original value, e.g. x 5
        sta     AXLeft
        pla
        adc     AXLeft+1
        sta     AXLeft+1
        bra     _AXMDouble                  ; double to x10

_AXMMultiply16:
        jsr     _AXMDouble                  ; x 2
        jsr     _AXMDouble                  ; x 4       
        jsr     _AXMDouble                  ; x 8, fall through to x 16
_AXMDouble:
        asl     AXLeft                      ; everyone does left.
        rol     AXLeft+1
_AXMExit:       
        rts

; ************************************************************************************************
;
;                           Get next non space character from buffer
;
; ************************************************************************************************

AXGet:
        lda     AXBuffer,x                  
        inx
        cmp     #' '
        beq     AXGet
        dex
        cmp     #0
        rts

; ************************************************************************************************
;
;                                   Extract and evaluate label
;
; ************************************************************************************************

AXEvaluateLabel:
        jsr     AXExtractIdentifier         ; get a label. 
        bcs     _AXEExit                    ; we couldn't.

        phx                                 ; save current position

        ldx     #0                          ; create or find the value.
        ldy     AXIBase
        jsr     AXICreateFind       
        ;
        ldy     #AXID_DataLow               ; copy data
        jsr     AXIGet
        sta     AXLeft+0

        ldy     #AXID_DataHigh
        jsr     AXIGet
        sta     AXLeft+1

        ldy     #AXID_Flags                 ; just the undefined flag.
        jsr     AXIGet
        and     #$80
        sta     AXLeft+2

        lda     #AXID_DataAux               ; get bank page of label.
        jsr     AXIGet
        sta     AXEvaluatePage 

        plx                                 ; restore current position.
        clc

_AXEExit:
        rts     

        .send as16code

        .section as16storage
AXDigitCount:                               ; number of digits in constant.
        .fill   1
AXBase:                                     ; temporary for base.
        .fill   1       
        .send as16storage       


