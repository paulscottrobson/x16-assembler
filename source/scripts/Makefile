# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	.... it's the make file.
#		Date :		11th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../../build_env/common.make

.any:

#
#		These copy files to source/assembler/generated
#
build:	.any
	$(PYTHON) exprtable.py
	$(PYTHON) makeasmtable.py
	$(PYTHON) makelib.py >$(BUILDDIR)/libassembler.asm
	$(PYTHON) makefarcall.py  "../api/x16/" >../api/x16/generated/__farcalls.inc

	echo "Scripts run successfully."