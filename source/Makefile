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

#
#		Pre build scripts which create various tables automatically and the main library file
#
prelim:
	$(CDEL) *.bin
	$(PYTHON) scripts$(S)exprtable.py
	$(PYTHON) scripts$(S)makeasmtable.py
	$(PYTHON) scripts$(S)makelib.py >build$(S)libassembler.asm
	$(CCOPY)  build$(S)libassembler.asm $(BINDIR)
#
#		Update rom/emulator from repos
#	
tools:
	$(CCOPY) $(ROOTDIR)..$(S)x16-emulator$(S)x16emu$(APPSTEM) $(BINDIR)
	$(CCOPY) $(ROOTDIR)..$(S)x16-rom$(S)build$(S)x16$(S)rom.bin $(BINDIR)
#
#		Evaluation tests.
#
test: prelim
	$(PYTHON) expr_testing$(S)expr.py >build$(S)testdata.inc
	$(ASSEMBLER) -D TESTING=1
	$(EMULATOR)

expr: prelim
	$(PYTHON) expr_testing$(S)setupexpr.py >build$(S)testdata.inc
	$(ASSEMBLER) -D TESTING=1
	$(CDEL) *.bin
	$(EMULATOR)
#
#		Dump identifier table.
#
ident:
	$(PYTHON) scripts$(S)showident.py 9000
#
#		Assemble with displayed output
#
run: prelim	
	$(CCOPY) testing$(S)dev.asm _code.asm
	$(ASSEMBLER) -D TESTING=2
	$(EMULATOR)
#
#		Assemble and exit
#
asm: prelim
	$(CCOPY) testing$(S)dev.asm _code.asm
	$(ASSEMBLER) -D TESTING=3
	$(EMULATOR)
#
#		Assemble, exit and compare against 64tass equivalent.
#
tests: 
	make opcodes
	make data
	make include
	make address
	make math
	
opcodes: prelim
	$(call check_assembler,opcodes)
data:prelim
	$(call check_assembler,data)
include:prelim
	$(call check_assembler,include)
address:prelim
	$(call check_assembler,address)
math:prelim
	$(call check_assembler,math)

define check_assembler	
	$(CCOPY) testing$(S)$(1).asm _code.asm
	$(ASSEMBLER) -D TESTING=3
	64tass --mw65c02 -b -o build/compare.bin -L build/compare.lst _code.asm
	$(EMULATOR)
	$(PYTHON) testing$(S)compare.py
endef
