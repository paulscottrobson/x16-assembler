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

ZEROPAGE = \$$30
STORAGE = \$$400

BINDIR = $(ROOTDIR)bin$(S)
BINFILE = build$(S)asm.prg
EMULATOR = $(BINDIR)x16emu$(APPSTEM) -prg $(BINFILE),1000 -run -debug -scale 2 -dump R
ASSEMBLER = 64tass -q -c -C -D ZEROPAGE=$(ZEROPAGE) -D STORAGE=$(STORAGE) -Wall main.asm -L build$(S)asm.lst -o $(BINFILE)

all: assemble

assemble: prelim
	$(ASSEMBLER) -D TESTING=0

prelim:
	$(CDEL) *.bin
	$(PYTHON) scripts$(S)expr.py
	$(PYTHON) scripts$(S)makelib.py >build$(S)libassembler.asm
	$(CCOPY)  build$(S)libassembler.asm $(BINDIR)
	
run: assemble
	$(EMULATOR)

tools:
	$(CCOPY) $(ROOTDIR)..$(S)x16-emulator$(S)x16emu$(APPSTEM) $(BINDIR)
	$(CCOPY) $(ROOTDIR)..$(S)x16-rom$(S)build$(S)x16$(S)rom.bin $(BINDIR)

test1: prelim
	$(PYTHON) testing$(S)expr.py >build$(S)testdata.inc
	$(ASSEMBLER) -D TESTING=1
	$(EMULATOR)