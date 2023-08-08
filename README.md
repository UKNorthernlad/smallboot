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
* QEMU = Quick Emulator

```
sudo apt install fasm nasm qemu
```
You don't need both fasm & nasm but having them both might be useful in the future.

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
