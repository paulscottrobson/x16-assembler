# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Test the assembler actually works , not main unit tests.
#		Date :		11th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../build_env/common.make

# *******************************************************************************************
#
#								Zero Page and Storage base (general)
#
# *******************************************************************************************

ZEROPAGE = \$$30
STORAGE = \$$400
MEMORYMAP = -D ZEROPAGE=$(ZEROPAGE) -D STORAGE=$(STORAGE)
BINFILE = $(BUILDDIR)asm.prg
EMULATOR = $(X16EMUDIR)$(EMULATOREXEC) -prg $(BINFILE),1000 -run -debug -scale 2 -dump R
ASSEMBLER = 64tass -q -c -C $(MEMORYMAP) -Wall main.asm -L $(BUILDDIR)asm.lst -o $(BINFILE) 

#EMULATOR = $(X16EMUDIR)$(EMULATOREXEC) -prg $(BINFILE),$(CODEADDRESS) -run -debug -scale 2 -dump R
#ASSEMBLER = 64tass -q -c -C $(DEFINES) -Wall $(MAINPROGRAM) -L $(BUILDDIR)asm.lst -o $(BINFILE) 

all: assemble

assemble: prelim
	$(ASSEMBLER) -D TESTING=0

prelim:
	$(MAKE) -C $(SCRIPTDIR) build

#
#		Dump identifier table (only for TESTING=3 which exits via jmp $FFFF)
#
ident:
	$(PYTHON) $(SCRIPTDIR)showident.py 9000

#
#		Assemble code.asm and run it
#
run: assemble
	$(ASSEMBLER) -D TESTING=2
	$(EMULATOR)
#
#		Assemble code.asm, run it, and exit immediately.
#
runexit: prelim
	$(ASSEMBLER) -D TESTING=3
	$(EMULATOR)
