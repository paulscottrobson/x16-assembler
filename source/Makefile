# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Build Basic
#		Date :		9th August 2023
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

# *******************************************************************************************
#								Zero Page and Storage base (general)
# *******************************************************************************************

ZEROPAGE = \$$30
STORAGE = \$$400

MEMORYMAP = -D ZEROPAGE=$(ZEROPAGE) -D STORAGE=$(STORAGE)

# *******************************************************************************************
#							  Identifier store and stack space
# *******************************************************************************************

ASMDATA = \$$9800
ASMDATAEND = \$$9C00
ASMDATACTL = 0

ASMDATADESC = -D ASMDATA=$(ASMDATA) -D ASMDATAEND=$(ASMDATAEND) -D ASMDATACTL=$(ASMDATACTL)

# *******************************************************************************************

BINDIR = $(ROOTDIR)bin$(S)
BINFILE = build$(S)asm.prg
EMULATOR = $(BINDIR)x16emu$(APPSTEM) -prg $(BINFILE),1000 -run -debug -scale 2 -dump R
ASSEMBLER = 64tass -q -c -C $(MEMORYMAP) $(ASMDATADESC) -Wall main.asm -L build$(S)asm.lst -o $(BINFILE) 

all: assemble

assemble: prelim
	$(ASSEMBLER) -D TESTING=0

prelim:
	$(PYTHON) scripts$(S)exprtable.py
	$(PYTHON) scripts$(S)makelib.py >build$(S)libassembler.asm
	$(CCOPY)  build$(S)libassembler.asm $(BINDIR)
	
run: assemble
	$(CDEL) *.bin
	$(EMULATOR)

tools:
	$(CCOPY) $(ROOTDIR)..$(S)x16-emulator$(S)x16emu$(APPSTEM) $(BINDIR)
	$(CCOPY) $(ROOTDIR)..$(S)x16-rom$(S)build$(S)x16$(S)rom.bin $(BINDIR)

test: prelim
	$(PYTHON) testing$(S)expr.py >build$(S)testdata.inc
	$(ASSEMBLER) -D TESTING=1
	$(CDEL) *.bin
	$(EMULATOR)

expr: prelim
	$(PYTHON) testing$(S)setupexpr.py >build$(S)testdata.inc
	$(ASSEMBLER) -D TESTING=1
	$(CDEL) *.bin
	$(EMULATOR)

ident:
	$(PYTHON) scripts$(S)showident.py $(ASMDATA)