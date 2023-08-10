use16       ; produce 16 bit code
org 0x7e00  ; Where we are expecting our kernel to be loaded to

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
    db "I am the kernel!",0 ; "db" = declare byte (or byte string).


