# Basic boot loader floppy

Taken from:
* https://www.youtube.com/watch?v=YBlJvoXAXDA  (appears to be someones personal re-recording of the first video in the following play list)
* https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN
* 
Newer and updated videos on the same subject: https://www.youtube.com/@sudocpp/videos

Add required VSCode extensions:

* "x86 and x86_64 Assembly" by 13xforever
* "Hex Editor" by Microsoft

Add required dev tools:

* FASM = Flat Assembler
* NASM = Netwide Assembler (https://nasm.us)
* QEMU = Quick x86 Emulator
* MTOOLS = Write files to an MS-DOS floppy without having to mount it first - https://en.wikipedia.org/wiki/Mtools
* DOSFSTOOLS = Tools to create and format Microsoft disks
```
sudo apt install fasm nasm qemu mtools dosfstools
```
>>> You don't need both fasm & nasm but having them both might be useful in the future.

The QEmu emulator does not have any built-in support to display CPU debugging, therefore another emulator called Bochs can be used.
* BOCHS = another emulator which has debugging support
```
sudo apt install bochs bochs-sdl bochsbios vgabios
```

>>> At time of writing, the Ubuntu package based on release 2.7 doesn't work correctly and displays "physical memory read error" when running (nor does the emulator display anything) - this seems to be documented at https://github.com/bochs-emu/Bochs/issues/50.

>>> Download source from https://github.com/bochs-emu/Bochs/releases/tag/REL_2_7_FINAL and then run `configure --with-sdl2 --enable-debugger"

## Examples

Print a basic "hello world" message by booting of a disk.
```
make hello
make runhello
```

Basic ways to manipulate memory 
```
make memory
make memoryrun
```

Print a basic "hello world" message by booting of a disk but using a function call and stack.
```
make hellocall
make runhellocall
```


## Commands used
* Create a blank disk image
* Format it with FAT 12
* Copy a file to the new disk (mcopy -i imagefile sourcefile destinationfile)
```
dd if=/dev/zero of=floppy.bin bs=512 count=2880
mkfs.fat -F 12 -n "Disk label" floppy.bin
mcopy -i floppy.bin README.md "::README.md"
```


## Useful links
https://wiki.osdev.org
