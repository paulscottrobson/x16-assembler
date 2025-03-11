# API Specification for X16-Assembler

This is the API spec. The simple API used is in the source/x16_api directory. It works on the X16 emulator.

| Cmd  | Purpose                                                      |
| :--: | ------------------------------------------------------------ |
|  0   | Set lower and upper high bytes of memory area to use in A Y. must be on page boundaries (e.g. A = $94, Y = $98 means use memory from $9400 to $97FF)<br/>Can be paged, as memory is locked/unlocked on access to the stack or the user identifier store.<br/>When locked the general storage used by the assembler must be accessible.<br/>Any initialisation code goes here. |
|  1   | Open character source YX where YX is an ASCIIZ string (external source) or NULL (default source). Returns CC (okay) CS (failed) and a reference handle in A.<br/>Note files will be 'stacked', so if a file is opened it will be closed before any other file is accessed. |
|  2   | Close character source, reference handle in X. As above, will be closed in the reverse order they are opened. |
|  3   | Read next character from source X => A. Returns CS if end of file *before* the read, e.g. it failed. After EOF it should continue to return CS on subsequent calls. |
|  4   | Output byte. Only called on pass 2. This is the actual generated code ; address $00+x contains address.low, address.high and page in 3 consecutive locations. <br/> The byte to write is in YIt is system dependent what to do with this. The simplest version is.<br/>*tya 			     ; byte to write in A<br/>sta 	($00,x) 	; write indirect via X.*<br/>which drops it in the specified memory location. |
|  5   | Report error. YX points to : +0 error code +1,2 line # (integer) +3,4 line # (bcd). Return CC to continue, CS to exit early. Error codes with bit 7 set are non recoverable. |
|  6   | Write to listing output X, pass 2 only. Characters are U/C. This can be ignored if you don't want listing but can simply send X to $FFD2 for example as is done in the demo API. |
|  7   | Lock the storage area e.g. page bank in or whatever. Memory used for storage must be accessible at this point. |
|  8   | Unlock the storage area                                      |



------

*Paul Robson *(paul@robsons.org.uk)*

*Version 1.00 (11 March 2025)*