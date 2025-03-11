; ************************************************************************************************
; ************************************************************************************************
;
;       Name:       errors.inc
;       Purpose:    Error codes
;       Created:    11th March 2025
;       Author:     Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section as16code

; ************************************************************************************************
;
;                                       Error codes
;
;                     lower 6 bits are ID, bit 7 identifies a fatal error.
;
; ************************************************************************************************

AXERREOF = $00                              ; end of file, not assembler error.
AXERRSyntax = $01                           ; general syntax error.
AXERRIdentifier = $02                       ; bad identifier, missing/too long.
AXERRDivZero = $03                          ; divide by zero.
AXERRRedefine = $04                         ; value of an identifier has changed.
AXERRNotFound = $85                         ; source file not found.
AXERRUndefined = $06                        ; undefined identifier.
AXERRRelative = $07                         ; relative branch range.
AXERRMode = $08                             ; address mode not supported in 65C02
AXERRSize = $09                             ; bad expression.
AXERRLength = $8A                           ; line too long.
AXERRMacroParams = $8B                      ; too many macro parameters.
AXERRParam = $8C                            ; bad expansion parameter.
AXERRMemory = $8D                           ; memory.

        .send as16code


