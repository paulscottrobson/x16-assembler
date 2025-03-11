; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       analyse.asm
;       Purpose:    Analyse the instruction parameters
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                       Analyse parameters (X points to end of identifier)
;
;       Creates table in frame of macro parameters - this is a list of positions in AXBuffer.
;                                               CS = Error
;       
; ************************************************************************************************

AXMAnalyseParameters:
        ldy     #0                          ; count the parameters
_AXMAPLoop:
        jsr     AXGet                       ; get the next.
        cmp     #0                          ; if not zero there is a parameter
        bne     _AXMAPParameter
        ;
_AXMAPExit:     
        sty     AXMParamCount               ; save the count of parameters
        txa                                 ; update the last position in the position list.
        sta     AXMParameters,y                 
        clc
        rts
        ;
_AXMAPParameter:
        cpy     #AXMaxParams                ; too many parameters
        beq     _AXMAPError
        ;
        txa                                 ; save the start of the parameter and increment the count
        sta     AXMParameters,y     
        iny
        ;
_AXMAPSkip:     
        jsr     AXGet                       ; get first non-space character
        cmp     #'"'                        ; quoted string handled seperately.
        beq     _AXMAPString        
        cmp     #0                          ; if End found then exit
        beq     _AXMAPExit
        inx                                 ; consume character
        cmp     #","                        ; keep getting if ,
        bne     _AXMAPSkip
        lda     #' '                        ; overwrite with a space so the comma isn't copied out.
        sta     AXBuffer-1,x
        bra     _AXMAPLoop                  ; see if another parameter follows.
        ;
_AXMAPString:
        inx                                 ; get next
        jsr     AXGet       
        cmp     #0                          ; exit if end of string
        beq     _AXMAPExit
        cmp     #'"'                        ; loop back if not closing quote
        bne     _AXMAPString
        inx                                 ; consume closing quote
        bra     _AXMAPSkip                  ; and keep looking.

_AXMAPError:
        lda     #AXERRMacroParams
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

