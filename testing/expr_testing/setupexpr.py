# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		setupexpr.py
#		Purpose :	Simple expressions etup
#		Date :		12th August 2023
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

expr = "3+2*4"

print("\t.byte {0}".format(len(expr)+4))
print("\t.text '{0}',0".format(expr))
print("\t.word 0")
