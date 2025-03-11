# *******************************************************************************************
# *******************************************************************************************
#
#       Name :      source.py
#       Purpose :   Source code conversion
#       Date :      11th March 2025
#       Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys

useWindowsFormat = True 

print(";\n;\tThis file is automatically generated.\n;")
for f in sys.argv[1:]:
    for s in open(f).readlines():
        s = s.rstrip()
        print(";\t ===== {0} ====".format(s))
        s = [ord(x) for x in s]
        s += [13,10] if useWindowsFormat else [10]
        print("\t.byte {0}".format(",".join([str(x) for x in s])))
print("\t.byte 0")      

