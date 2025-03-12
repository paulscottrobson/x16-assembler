# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Top level Makefile
#		Date :		11th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include build_env/common.make

#
#		Does a test build of the library module
#
build:
	$(MAKE) -B -C source
#
#		Runs the scripts which generate files. If you get file not found errors might be this
#
scripts:
	$(MAKE) -B -C $(SCRIPTDIR) build
#
#		Run the tests
#
test:
	$(MAKE) -B -C testing test
