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

BINDIR = $(ROOTDIR)bin$(S)
BINFILE = build$(S)asm.prg
EMULATOR = $(BINDIR)x16emu$(APPSTEM) -prg $(BINFILE),1000 -run -debug -scale 2 -dump R
ASSEMBLER = 64tass -c -C $(MEMORYMAP) -Wall main.asm -L build$(S)asm.lst -o $(BINFILE) 

all: assemble

assemble: prelim
	$(ASSEMBLER) -D TESTING=0

prelim:
	$(PYTHON) scripts$(S)exprtable.py
	$(PYTHON) scripts$(S)makeasmtable.py
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

asm: prelim	
	# $(PYTHON) testing$(S)source.py testing$(S)source.txt >assembler$(S)generated$(S)sourcebytes.dat
	$(ASSEMBLER) -D TESTING=2
	$(CDEL) *.bin
	$(EMULATOR)
