hello:
	fasm hello.asm

runhello:
	qemu-system-x86_64 --drive format=raw,file=hello.bin
