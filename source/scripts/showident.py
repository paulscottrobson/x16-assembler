# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		showident.py
#		Purpose :	Show the identifier table
#		Date :		11th August 2023
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,re

addr = int(sys.argv[1][1:],16)	
mem = [x for x in open("dump.bin","rb").read(-1)]


while mem[addr] != 0:
	name = ""
	p = addr + 6
	while p != 0:
		name += chr(mem[p] & 0x7F)
		p = 0 if mem[p] >= 0x80 else p+1
	print("@${0:04x} {6:<15} Hash:${1:02x} Type:${2:02x} Flags:${3:02x} Data ${5:02x} ${4:02x}".format(addr,mem[addr+1],mem[addr+2],mem[addr+3],mem[addr+4],mem[addr+5],name))
	addr += mem[addr]
