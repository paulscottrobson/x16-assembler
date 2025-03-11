; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       text.asm
;       Purpose:    .text command (byte with possible tex string)
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                               Assemble .text command
;
; ************************************************************************************************

AXTextCmd:  ;; {.text}

        ldx     AXOperandPos                ; get operand, must be defined even on pass 1.

_AXTLoop:
        jsr     AXGet                       ; is it a quoted string
        cmp     #'"'
        beq     _AXTText

        jsr     AXPass2Expression           ; get value
        bcs     _AXTExit

        lda     AXPass                      ; only check size on pass 2
        cmp     #2
        bne     _AXTNoCheck

        lda     AXLeft+1
        beq     _AXTNoCheck

        lda     #AXERRSize                  ; not a byte.
        sec
        rts

_AXTNoCheck:
        lda     AXLeft                      ; output the byte.
        jsr     AXWriteByte
_AXTNext:
        jsr     AXGet                       ; get next
        inx
        cmp     #","
        beq     _AXTLoop
        cmp     #0
        bne     _AXTSyntax
_AXTOkay:       
        clc
        rts

_AXTText:
        jsr     AXTGetTextString            ; get text string to buffer.
        bcs     _AXTExit                    ; failed
        ldy     #0
_AXTOut:
        lda     AXTextParameter,y           ; get character
        beq     _AXTNext                    ; end of string, do next parameter
        jsr     AXWriteByte
        iny                                 ; keep going.
        bra     _AXTOut
_AXTSyntax:
        lda     #AXERRSyntax
        sec
_AXTExit:       
        rts

; ************************************************************************************************
;
;                           Get text string into seperate buffer
;
; ************************************************************************************************

AXTGetTextString:
        jsr     AXGet                       ; get first
        cmp     #'"'                        ; error if not double quotes
        bne     _AXTGError
        ldy     #0
_AXGTSLoop:
        inx                                 ; get the next
        lda     AXBuffer,x
        beq     _AXTGError                  ; EOL
        cmp     #'"'                        ; found end
        beq     _AXTGExit
        sta     AXTextParameter,y           ; write into buffer
        iny
        bra     _AXGTSLoop
_AXTGExit:
        inx                                 ; consume closing "
        lda     #0                          ; make ASCIIZ
        sta     AXTextParameter,y                   
        clc
        rts

_AXTGError:
        sec
        lda     #AXERRSyntax
        rts

        .send as16code
        

