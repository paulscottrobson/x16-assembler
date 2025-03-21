; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      apifile.asm
;       Purpose :   API Open/Read/Close
;       Date :      11th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                           Open a file
;
; ************************************************************************************************

TAOpen: 
        cpx     #0                          ; check default name ?
        bne     _TAHaveName
        cpy     #0
        bne     _TAHaveName

        ldx     #<_FileName                 ; use default.
        ldy     #>_FileName
        lda     #7                          ; reset handle tracker
        sta     TAHandleTracker
        stz     TAIsEOF                     ; reset EOF flag.
_TAHaveName:
        stx     TATemp0                     ; get length
        sty     TATemp0+1
        ldy     #255
_TAGetLen:
        iny
        lda     (TATemp0),y
        bne     _TAGetLen
        tya                                 ; A = size, XY = filename
        ldy     TATemp0+1
        farjsr  FFBD                        ; SETNAM

        inc     TAHandleTracker
        lda     TAHandleTracker
        pha
        ldx     #8
        tay
        farjsr  FFBA                        ; set LFS

        farjsr  FFC0                        ; OPEN, 
        farjsr  FFB7                        ; READST
        adc     #$FF                        ; set CS on error (A != 0)
        pla
_TAOExit:           
        rts

_FileName:
        .text   'CODE.ASM',0

; ************************************************************************************************
;
;                                       Close file handle in X
;
; ************************************************************************************************

TAClose:
        txa
        farjsr  FFC3                        ; CLOSE
        farjsr  FFCC                        ; CLRCHN
        dec     TAHandleTracker
        clc
        rts     

; ************************************************************************************************
;
;                               Read a character from the input stream X.
;
; ************************************************************************************************

TAReadChar:
        bit     TAIsEOF                     ; last read reached EOF ?
        bvs     _TAFail                     ; surely there has to be a better way to read a bloody sequential file ?
        farjsr  FFC6                        ; CHKIN
        farjsr  FFCF                        ; CHRIN
        pha
        farjsr  FFB7                        ; READST
        and     #64                         ; EOF next read.
        sta     TAIsEOF
        pla
        clc
        rts
_TAFail:
        stz     TAIsEOF                     ; clear EOF Flag
        farjsr  FFCC                        ; CLRCHN
        sec
        rts     

        .send as16code

        .section as16zeropage
TATemp0:
        .fill   2
TAIsEOF:
        .fill   1       
        .send as16zeropage


