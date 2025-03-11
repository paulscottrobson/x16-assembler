; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      apifarcall.asm
;       Purpose :   Far Call handler code
;       Date :      11th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;                                 Call the appropriate farjsr routine
;
; ************************************************************************************************

farjsr  .macro 
        jsr     $\1
        .endm

        .section as16code

TA_FarCall_Table:
        .include "generated/__farcalls.inc"
TA_FarCall_Table_End:

        .send as16code

        .section as16storage

TA_FarCall_RAM_Table:
        .fill   TA_FarCall_Table_End - TA_FarCall_Table        

        .send as16storage


