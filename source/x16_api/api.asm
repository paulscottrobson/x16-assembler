; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      api.asm
;       Purpose :   Sample Assembbler API.
;       Date :      11th March 2025
;       Reviewed :  No
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
; ************************************************************************************************
;
;                                           API Entry Point
;
; ************************************************************************************************
; ************************************************************************************************

SampleAPIHandler:
        cmp     #AXAPISetup
        beq     _TAMemInfo
        cmp     #AXAPIOpen
        beq     _TAOpen
        cmp     #AXAPIClose
        beq     _TAClose
        cmp     #AXAPIReadByte
        beq     _TAReadChar
        cmp     #AXAPIWriteByte
        beq     _TAWriteByte
        cmp     #AXAPIError
        beq     _TAError
        cmp     #AXAPIListChar
        beq     _TAListChar
        ;
        ;       Lock/Unlock are not implemented as the storage is not in banked memory.
        ;
        clc
        rts

; ************************************************************************************************
;
;                           Memory information and initialisation
;
; ************************************************************************************************

_TAMemInfo:
        lda     #$90                        ; memory from $9000 - $9EFF
        ldy     #$9F
        clc
        rts     

_TAOpen:
        jmp     TAOpen
_TAClose:
        jmp     TAClose
_TAReadChar:
        jmp     TAReadChar
_TAWriteByte
        jmp     TAWriteByte
_TAListChar:
        jmp     TAListChar
_TAError:
        jmp     TAError

        .include "apilist.asm"
        .include "apiwrite.asm"
        .include "apifile.asm"
        .include "apierror.asm"
        
        .send as16code

        .section as16storage
TAHandleTracker:
        .fill    1          
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

