# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		makeasmtable.py
#		Purpose :	Build the assembler information structure.
#		Date :		11th August 2023
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,re

# *******************************************************************************************
#
#									Single mnemonic class
#
# *******************************************************************************************

class MnemonicBase(object):
	#
	def __init__(self,group,mnemonic,opcode,operand):
		self.group = group
		self.mnemonic = mnemonic
		self.opcode = opcode
	#
	def toString(self):
		return "{0:4} ${2:02x} Group:{1}".format(self.mnemonic,self.group,self.opcode)

class Mnemonic(MnemonicBase):
	pass

class MnemonicGroup2(MnemonicBase):
	def __init__(self,group,mnemonic,opcode,operand):
		MnemonicBase.__init__(self,group,mnemonic,opcode,"")	
		operand = operand.strip().replace(" ","")
		assert len(operand) == 8,"Bad selector on "+MnemonicBase.toString(self)
		self.select = int(operand.replace("-","0").replace("X","1"),2)
	#
	def toString(self):
		return MnemonicBase.toString(self)+" Use:{0:08b}".format(self.select)

# *******************************************************************************************
#
#									Assembler Dictionary Class
#
# *******************************************************************************************

class AssemblerDictionary(object):
	def __init__(self):
		self.objects = {}
		self.fixes = []
		self.load()

	def load(self):
		for s in open("scripts/opcodes/opcodes.txt").readlines():
			s = s.strip().upper().replace("\t"," ")
			if not s.startswith(";") and s != "":
				m = re.match("^([0-9A-F]+)\\s+(\\w+)\\s+(\\d)\\s*(.*)$",s)
				assert m is not None,"Bad entry '"+s+"'"
				groupID = int(m.group(3))
				if groupID == 5:
					m2 = re.match("\\s*(\\d+)\\s*(.*)",m.group(4))
					assert m2 is not None,"Bad table "+m.group(4)
					arec = self.objects[m.group(2)]
					newFix = [m.group(2),arec.opcode,int(m.group(1),16),int(m2.group(1),16),m2.group(2).strip()]
					self.fixes.insert(0,newFix)
				else:
					if groupID == 2:
						mnm = MnemonicGroup2(groupID,m.group(2),int(m.group(1),16),m.group(4).strip())
					else:
						mnm = Mnemonic(groupID,m.group(2),int(m.group(1),16),m.group(4).strip())
					assert m.group(2) not in self.objects,"Duplicate "+s
					self.objects[m.group(2)] = mnm

ad = AssemblerDictionary()
print([x for x in ad.objects.keys()])
print(ad.fixes)