hello:
	fasm hello.asm

memory:
	fasm memory.asm

hellocall:
	fasm hellocall.asm

runhello:
	qemu-system-x86_64 --drive format=raw,file=hello.bin

runmemory:
	qemu-system-x86_64 --drive format=raw,file=memory.bin

runhellocall:
	qemu-system-x86_64 --drive format=raw,file=hellocall.bin
