# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		common.make
#		Purpose :	Common make
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
#									Build helpers
#
# *******************************************************************************************

EMULATOR = $(X16EMUDIR)$(EMULATOREXEC) -prg $(BINFILE),$(CODEADDRESS) -run -debug -scale 2 -dump R
ASSEMBLER = 64tass -q -c -C $(DEFINES) -Wall $(MAINPROGRAM) -L $(BUILDDIR)asm.lst -o $(BINFILE) 

# *******************************************************************************************
#
#				    Uncommenting .SILENT will shut the whole build up.
#
# *******************************************************************************************

ifndef VERBOSE
.SILENT:
endif

default: build 

