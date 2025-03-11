; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       macro.asm
;       Purpose:    .macro command
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                   .macro definition
;
; ************************************************************************************************

AXXMacro:   ;; {.macro}
        jsr     AXReadLine                  ; read the next line
        bcs     _AXMExit                    ; error ?
        jsr     AXMCheckEnd                 ; is this .endm
        bcs     _AXMComplete
        ;
        lda     AXPass                      ; only do the define on pass 1.
        cmp     #2
        beq     AXXMacro
        ;
        clc                                 ; append the buffer to the macro.
        jsr     AXIAppendMacro
        bcs     _AXMExit                    ; failed ?
        bra     AXXMacro
        ;
_AXMComplete:                               ; do nothing on pass 2.
        lda     AXPass
        cmp     #2
        beq     _AXMExitOkay

        sec                                 ; this appends the NULL to the macro.
        jsr     AXIAppendMacro

_AXMExitOkay:
        clc
_AXMExit:       
        rts

; ************************************************************************************************
;
;                               Check if buffer contains .ENDM
;
; ************************************************************************************************

AXMCheckEnd:
        ldx     #0                          ; first non space.
        jsr     AXGet 
        ldy     #0
_AXMCheck:
        lda     AXBuffer,x                  ; match ?
        cmp     _AXMMarker,y
        clc                                 ; no, return CC
        bne     _AXMExit
        inx                                 ; next chars
        iny
        cmp     #0                          ; two NULLs matched ?
        bne     _AXMCheck                   ; yes, then found .endm
        sec
_AXMExit:
        rts

_AXMMarker:
        .text   ".ENDM",0

        .send as16code
        

