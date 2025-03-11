# **Commander X16 Assembler**

This is the specification for a reuseable 65C02 assembler for the Commander X16. It is MIT open source, so should run on any machine that uses a 65C02 or compatible.

## Assembler

The assembler will be standard 65C02 mnemonics with the standard variations (e.g. ASL / ASL A), operating as a 2 pass assembler. 

Labels are identified either as an unknown mnemonic or ending with a colon. ; delimits comments outside quoted strings.

Line lengths are limited to 80 characters.

## Expressions

Expressions will support the following using 16 bits :

- Binary operators with standard precedence : + - * / % & (and) | (or) ^ (exclusive or) >> << (shift right/left)
- Unary operators : - (parenthesis) * (program counter) > and < (lower and upper 8 bits),@label (returns bank/undefined)
- Terms : label, decimal, $[hexadecimal] %[binary] ‘[character code]’

A label consists of an alphabetic character followed by a sequence of alphanumeric characters or underscore. Labels beginning with underscore only have scope between two labels beginning with an alphabetic character.

## Pseudo Operations

Standard 65C02 pseudo-operations are : *need to check these were actually implemented*

| Operation            | Function                                                     |
| -------------------- | ------------------------------------------------------------ |
| .byte [values]       | Adds a sequence of bytes (also .db)                          |
| .word [values]       | Adds a sequence of words in low/high order (also .dw)        |
| .text [string\|byte] | Sequence of quoted strings (ASCII) or bytes, can be mixed    |
| .fill [count]        | Allocates an area of memory but doesn't assemble anything there. |
| .include [file]      | Include a source file                                        |
| .align [value]       | Puts on align byte boundary.                                 |
| .bank                | Next bank                                                    |
| .bank [index]        | Select bank                                                  |
| .binary [file]       | Include binary file (also .incbin)                           |
| .macro               | Define macro (see below)                                     |

## Macros

Text substitution macros are permitted to a depth of probably 4 to 5.

| Operation     | Function                                |
| ------------- | --------------------------------------- |
| .macro [name] | Defines a macro                         |
| .endm         | Ends a macro                            |
| \1 \2 \3      | Text substitutions of up to 3 arguments |

An issue here is are these arguments allowed to be quoted strings *did I do this ?*. While this is tempting it does create some storage issues. Perhaps initially not, but consider the possibility of adding such later .

### Example

```
	.macro set16
	lda 	#(>\2)
	sta 	\1
	lda 	#(<\2)
	sta 	1+(\1)
	.endm
```

## Interface

To maximise reusability the assembler operates through a simple API. 

On the input side, one can open a file, read a byte from it (assuming ASCII) and close it, this is done at an abstraction level one above the Kernal. 

RAM based assembly can be done with a faux file “RAM” or similar, which returns a stream from the location the editor text is stored in.

On the output side, a vector is provided when starting the assembler which receives the target address and code, with which it can do what it likes, store it in that target address, write it to a file etc.

Errors are returned individually along with a line number and file name.

If a classic assembler listing Is required this could be done using another vector which receives a stream of ASCII characters, again, the system may do what it wishes with it.

------

*Paul Robson *(paul@robsons.org.uk)*

*Version 1.00 (11 March 2025)*