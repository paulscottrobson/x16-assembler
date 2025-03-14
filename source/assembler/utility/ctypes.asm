; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       ctypes.asm
;       Purpose:    Simple character functions
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                   Convert lower to upper case
;
; ************************************************************************************************

AXConvertUpper:
        cmp     #"a"
        bcc     _AXCNotUpper
        cmp     #"z"+1
        bcs     _AXCNotUpper
        eor     #$20
_AXCNotUpper:
        rts     

; ************************************************************************************************
;
;                       Check U/C alphabetic (return CC = True, CS = False)
;
; ************************************************************************************************

AXIsAlpha:
        cmp     #"A"
        bcc     _AXNotAlpha
        cmp     #"Z"+1
        bcs     _AXNotAlpha
        rts
_AXNotAlpha:
        sec
        rts     

; ************************************************************************************************
;
;                       Check Decimal Digit (return CC = True, CS = False)
;
; ************************************************************************************************

AXIsNumeric:
        cmp     #"0"
        bcc     _AXNotDigit
        cmp     #"9"+1
        bcs     _AXNotDigit
        rts
_AXNotDigit:
        sec
        rts     

; ************************************************************************************************
;
;                      Check U/C alphanumeric (return CC = True, CS = False)
;
; ************************************************************************************************

AXIsAlphaNumeric:
        jsr     AXIsAlpha                   ; if alpha then exit with yes
        bcs     AXIsNumeric                 ; no, depends on is numeric
        rts

; ************************************************************************************************
;
;                               Is an identifier HEAD character A-Z _ .
;
; ************************************************************************************************

AXIsIdentifierHead:
        jsr     AXIsAlpha
        bcs     AXCheckIdentifierMisc
        rts

; ************************************************************************************************
;
;         Check for non alphanumeric character allowed in identifier, currently _ and .
;
; ************************************************************************************************

AXCheckIdentifierMisc:       
        cmp     #"_"
        beq     _AXIsIdentB
        cmp     #"."
        beq     _AXIsIdentB
        sec
        rts
_AXIsIdentB:
        clc
        rts

; ************************************************************************************************
;
;                               Is an identifier body character A-Z 0-9 _ .
;
; ************************************************************************************************
        
AXIsIdentifierBody:
        jsr     AXIsAlphaNumeric
        bcs     AXCheckIdentifierMisc
        rts

        .send as16code


