; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       appendmacro.asm
;       Purpose:    Add the buffer string to the last defined word
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;           For the last defined label in the list, set type to Macro and ....
;
;           Add the ASCIIZ string in the buffer to the macro text with CR (Carry Clear)
;           Add $FF to macro text (Carry Set)
;
; ************************************************************************************************

AXIAppendMacro: 
        php                                 ; save end marker/line flag.
        jsr     AXIOpen                     ; start.
        ;   
        ;       Make AXTemp0 point to the *last* entry, which is a macro.
        ;
        lda     AXIBase
        sta     AXTemp0+1
        stz     AXTemp0                     ; save address at zTemp0
        ;
_AXIFindLast:   
        lda     (AXTemp0)                   ; read the *next* link
        tay
        lda     (AXTemp0),y
        beq     _AXIFoundLast               ; if zero, we're at the last defined.
        ;
        tya                                 ; move to next.
        clc
        adc     AXTemp0
        sta     AXTemp0
        bcc     _AXIFindLast
        inc     AXTemp0+1
        bra     _AXIFindLast
_AXIFoundLast:
        ldy     #AXID_Type                  ; set the type to macro.
        lda     #AXIT_Macro
        sta     (AXTemp0),y

        plp                                 ; type of operation required.
        bcs     _AXIInsertNull
        ldx     #0                          ; insert the buffer
_AXIInsertBuffer:
        lda     AXBuffer,x                  ; if end of line insert $00 and exit
        beq     _AXIInsertA     
        jsr     _AXIInsert                  ; insert character
        inx                                 ; do next
        bra     _AXIInsertBuffer    
        ;
_AXIInsertNull:
        lda     #$FF                        ; insert a $FF marking macro end.
_AXIInsertA:        
        jsr     _AXIInsert
        jsr     AXIClose                    ; close access
        clc
        rts


_AXIInsert:
        pha                                 ; save insertable.
        lda     (AXTemp0)                   ; get offset to end.
        tay                                 ; now points to next free character
        pla                                 ; write new character out.
        sta     (AXTemp0),y
        iny                                 ; write new end-next-link-zero
        lda     #0
        sta     (AXTemp0),y
        ;
        tya                                 ; bump length by one.
        iny
        sta     (AXTemp0)
        rts
        
        .send as16code


