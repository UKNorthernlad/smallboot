use16       ; produce 16 bit code
org 0x7c00  ; assume code will be loaded at memory location 0x7c00. This is where the BIOS expects it to be.

; The BIOS has a number of interrupt routines that can perform tasks needed for startup, e.g. print on the screen.
; These can be triggered by either hardware or software calls with the "int" instruction.
; These are documented at https://en.wikipedia.org/wiki/BIOS_interrupt_call

; Some interrupts can have a parameter passed on the "ah" register to provide more fine grained control,

;Example
;=======
;mov ah, 0x0e    ; function number = 0Eh : Display Character on screen
;mov al, '!'     ; AL = code of character to display. This is like the parameter to the interrupt.
;int 0x10        ; call INT 10h, BIOS video service https://en.wikipedia.org/wiki/INT_10H

mov ah, 0x0  ; Set video mode subroutine...
mov al, 3    ; Set to mode 3 ==> 80x25 16 bit colour - http://www.columbia.edu/~em36/wpdos/videomodes.txt - SeaBIOS used by qemu is limited to 0,1,2,3
;mov ax, 3h ; would have done the same.
int 10h    ; Invoke the interrupt. This will now resize and clear the screen.

;Now write something to the screen - the "al" contains the single byte we want to write.
;mov ah, 0xe
;mov al, 'H'
;int 10h

; Write something out using a loop
mov si, msg ; The "si" register is one of the index registers. It contains the location of the string we want to iterate over and print.
mov ah, 0xe ; function number 0xe : Display a character on screen.

displayLoop:
    lodsb ; Load the value of the single byte (sb) pointed to by the "si" register into the "al" register then increment the value in the "si" register
    ;mov al, 'H' ; no need to manually add our letter, as the lodsb command did this for us
    or al,al ; Take the number in "al" and OR it with the number in "al" (which then puts the result back into "al"). Since OR'ing a number with itself won't change it, the value in "al" is never changed. However, if the result value is 0, the ZERO flag is set. This is a check for a NULL character in the output string.
    jz halt  ; If the ZERO flag it set, jump to the halt label.
    int 10h  ; Call the interrupt to display the current letter.
    jmp displayLoop ; Loop around and print every letter in the string.

halt:
    cli ; stop all interrupts
    hlt ; halt the system

msg:
    db "Hello world!",0

times 510 - ($-$$) db 0 ; Write out 510 null bytes. The ($-$$) bit is a count of the number of bytes written out already. If that was say 10, it would mean that only 500 null bytes are written. This keeps the total bytes written out to 512 regardless of the number written out already.
dw 0xaa55 ; The magic byte sequence to mark this sector as bootable.

