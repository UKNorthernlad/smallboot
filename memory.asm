use16       ; produce 16 bit code
;bits 16 ; when using NASM as the assembler.
org 0x7c00  ; assume code will be loaded at memory location 0x7c00. This is where the BIOS expects it to be and all offsets are calculated from this address.

mov ax, variable ; - copy the raw memory address of variable into "ax".
mov ax, [variable] ; copy memory contents of location "variable" into "ax".

; To access the 2nd item in an array
mov bx, array      ; copy offset to bx
mov si, 2 * 2     ; array[2], words are 2 bytes wide
mov ax, [bx + si] ; copy memory contents

halt: 
    cli; FA - Clear interrupt flag
    hlt; F4 - Halt the processor

variable:
    db 0x41

array:
    dw 100, 200, 300

bootdisk:
    times 510 - ($-$$) db 0 ; Write out 510 null bytes. The ($-$$) bit is a count of the number of bytes written out already. If that was say 10, it would mean that only 500 null bytes are written. This keeps the total bytes written out to 512 regardless of the number written out already.
    dw 0xaa55 ; Declare word (dw) writes a 2-byte sequence to set the magic number of mark this sector as bootable.
