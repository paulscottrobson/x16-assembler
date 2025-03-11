# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	.... it's the make file.
#		Date :		9th August 2023
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
	echo "Scripts run successfully."