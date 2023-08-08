org 0x7c00
use16

start:
    jmp main

; Prints a string to the screen
; Params:
;   -   ds:si points to the string

puts:
    ; save copies of the registers we will modify
    push si
    push ax

.loop:
    lodsb   ; loads next character in al
    or al,al ; check for null character (zero flag jump)
    jz .done
    
    mov ah, 0x0e
    mov bh, 0
    int 10h
    jmp .loop

.done:
    pop ax
    pop si
    ret

main:
    ;setup data segments to zero
    mov ax, 0  ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss,ax ; stack segment 0
    mov sp, 0x7c00  ; stack grows downwards from where we are loaded in memory

    ;print message
    mov si, message
    call puts

    hlt

message:
    db "Hello world" ,0


times 510 - ($-$$) db 0
dw 0xaa55