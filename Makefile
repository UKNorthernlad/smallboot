.PHONY: all floppy kernel bootloader clean

floppy:  bootloader kernel
	dd if=/dev/zero of=floppy.bin bs=512 count=2880
	# This will make a standard bootable floppy disk marked with 0xaa55 in 511/512 with FAT12
	mkfs.fat -F 12 -n "Disk label" floppy.bin
	# Write the bootloader into the first sector of the disk. This contains our manually contructed FAT12 header and executable code to print Hello.
	dd if=bootloader/bootloader.bin of=floppy.bin conv=notrunc
	#mcopy -i floppy.bin kernel/kernel.bin "::kernel.bin"
	# Write our kernel to the 2nd sector
	dd if=kernel/kernel.bin of=floppy.bin seek=1 bs=512 conv=notrunc

bootloader:
	fasm bootloader/bootloader.asm bootloader/bootloader.bin

kernel:
	fasm kernel/kernel.asm kernel/kernel.bin

run: 
	qemu-system-x86_64 --drive format=raw,file=floppy.bin

clean:
	rm bootloader/*.bin
	rm kernel/*.bin
	rm *.bin

debug:
	bochs -f config