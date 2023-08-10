# Basic boot loader floppy

Inital basic examples taken from:
* https://www.youtube.com/watch?v=YBlJvoXAXDA
* https://www.youtube.com/@sudocpp/videos

Main content take from this playlist:
* https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN
 
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
> You don't need both fasm & nasm but having them both might be useful in the future.

The QEmu emulator does not have any built-in support to display CPU debugging, therefore another emulator called Bochs can be used.
```
sudo apt install bochs bochs-sdl bochsbios vgabios
```
> At time of writing, the Ubuntu package based on release 2.7 of Bochs doesn't work correctly and displays "physical memory read error" when running (nor does the emulator display anything) - this seems to be documented at https://github.com/bochs-emu/Bochs/issues/50. You can download source from https://github.com/bochs-emu/Bochs/releases/tag/REL_2_7_FINAL and then run `configure --with-sdl2 --enable-debugger", followd by `make`. I never got this working on WSL on Windows, but as a TODO: I might try it on a real Ubuntu machine.

## Examples

Print a basic "hello world" message by booting of a disk.
```
cd 0-basicasmexamples
make hello
make runhello
```

Basic ways to manipulate memory 
```
cd 0-basicasmexamples
make memory
make memoryrun
```

Print a basic "hello world" message by booting of a disk but using a function call and stack.
```
cd 0-basicasmexamples
make hellocall
make runhellocall
```

Boot off a FAT12 disk, execute a bootloader which then loads a kernel (which just prints "hello world")
```
cd 1-boot-kernel-from-2nd-sector
make
make run
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
* https://wiki.osdev.org
* https://littleosbook.github.io/
