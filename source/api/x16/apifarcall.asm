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
;                             Call the appropriate farjsr routine
;                     The parameter is the 4 digit hex address e.g. FFD2
;
; ************************************************************************************************

farjsr  .macro 
        ;
        ;       This calls using the RAM Copy of the Far Call table.
        ;
        jsr     TA_Call_\1 - TA_FarCall_Table + TA_FarCall_RAM_Table
        ;
        ;       This one calls directly.
        ;  
;       jsr     $\1
        .endm

        .section as16code

; ************************************************************************************************
;
;                                Copy the table to the RAM duplicate
;
; ************************************************************************************************

TA_CopyCallToRAM:
        ldx     #0
_TALoop:
        lda     TA_FarCall_Table,x
        sta     TA_FarCall_RAM_Table,x
        inx
        cpx     #TA_FarCall_Table_End-TA_FarCall_Table
        bne     _TALoop        
        rts

; ************************************************************************************************
;
;       Autogenerated table of JSRFAR call : TA_Call_XXXX where XXXX is the routine address.
;
; ************************************************************************************************

TA_FarCall_Table:
        .include "generated/__farcalls.inc"
TA_FarCall_Table_End:

        .send as16code

        .section as16storage

TA_FarCall_RAM_Table:
        .fill   TA_FarCall_Table_End - TA_FarCall_Table        

        .send as16storage


