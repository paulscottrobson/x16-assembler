# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		common.make
#		Purpose :	Common make stuff.
#		Date :		11th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

# *******************************************************************************************
#
#										Configuration
#
# *******************************************************************************************

ASSEMBLER = 64tass
PYTHON = python3
MAKE = make --no-print-directory 
EMULATOREXEC = x16emu

# *******************************************************************************************
#
#										Directories
#
# *******************************************************************************************
#
#		Home of the X16 emulator binary and rom.bin
#
X16EMUDIR = /aux/builds/x16-emulator/
#
#		Root directory of repo
#
ROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
#
#		Stores executables
#
BINDIR = $(ROOTDIR)bin/
#
#  		Artefacts of builds.
#
BUILDDIR = $(ROOTDIR)build/
#
#		Where the build environment files are (e.g. like this)
#
BUILDENVDIR = $(ROOTDIR)build_env/
#
# 		Source related files.
#
SOURCEDIR = $(ROOTDIR)source/
#
#		Python script directory
#
SCRIPTDIR = $(SOURCEDIR)scripts/
#
#
#
# *******************************************************************************************
#
#								Build Configuration
#
# *******************************************************************************************
#
#		Use zero page from here (uses 3 bytes)
#
ZEROPAGE = \$$30
#
#		Use non zero page from here. (uses 240 bytes)
#
STORAGE = \$$400

# *******************************************************************************************
#
#									Build helpers
#
# *******************************************************************************************

MEMORYMAP = -D ZEROPAGE=$(ZEROPAGE) -D STORAGE=$(STORAGE)
BINFILE = $(BUILDDIR)asm.prg
#
#		Run the x16 emulator
#
EMULATOR = $(X16EMUDIR)$(EMULATOREXEC) -prg $(BINFILE),1000 -run -debug -scale 2 -dump R
#
#		Run the assembler
#
ASSEMBLER = 64tass -q -c -C $(MEMORYMAP) -Wall $(SOURCEDIR)main.asm -L $(BUILDDIR)asm.lst -o $(BINFILE) 

asm: prelim
	$(ASSEMBLER) -D TESTING=0

prelim:
	rm -f dump*.bin
	$(MAKE) -C $(SCRIPTDIR) build

#
#		Dump identifier table (only for TESTING=3 which exits via jmp $FFFF)
#
ident:
	$(PYTHON) $(SCRIPTDIR)showident.py 9000

#
#		Assemble code.asm and run it
#
run: prelim
	$(ASSEMBLER) -D TESTING=2
	$(EMULATOR)
#
#		Assemble code.asm, run it, and exit immediately.
#
runexit: prelim
	$(ASSEMBLER) -D TESTING=3
	$(EMULATOR)

# *******************************************************************************************
#
#				    Uncommenting .SILENT will shut the whole build up.
#
# *******************************************************************************************

ifndef VERBOSE
.SILENT:
endif

default: build 

