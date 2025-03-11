; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       macro.asm
;       Purpose:    Assemble a macro
;       Created:    11th March 2025
;       Reviewed:   No
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                   Assemble a macro, parameters from X.
;
; ************************************************************************************************

AXPAssembleMacro:
        jsr     AXMAnalyseParameters        ; work out the parameters limits.
        bcs     _AXPAMExit                  ; error (probably too many parameters)
        jsr     AXIBumpLocal                ; we need new locals.

        jsr     AXIGetDataAddress           ; get address of macro data => YX

        phx
        phy
        jsr     AXPushFrame                 ; save current frame preserving YX
        ply
        plx

        stx     AXMPointer                  ; save macro expansion pointer in current frame.
        sty     AXMPointer+1

_AXPALoop:
        jsr     AXIGetDataLine              ; get data line
        bcs     _AXPADone                   ; end of lines.
        
_AXPAParam:
        jsr     AXMScanParameters           ; look for parameters
        bcs     _AXPAMacroFailed            ; error in expansion ?
        cmp     #0                          ; if one replaced retry.
        bne     _AXPAParam

        jsr     AXAssembleLine              ; assemble that line
        bcs     _AXPAMacroFailed            ; something went wrong.
        jsr     AXListLine                  ; list the line.
        bra     _AXPALoop

_AXPADone:      
        jsr     AXPullFrame                 ; pull previous frame
        clc                                 ; return okay
_AXPAMExit:
        rts

_AXPAMacroFailed:
        pha                                 ; save error code
        jsr     AXPullFrame                 ; restore frame
        pla                                 ; get error code back and return error.
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

