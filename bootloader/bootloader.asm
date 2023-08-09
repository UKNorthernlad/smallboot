org 0x7c00
use16

define ENDLINE 0x0d, 0x0a

; This creats a bootable 512 byte sector FAT 12 header.
; The first three bytes EB 3C 90 disassemble to JMP SHORT 3C NOP. (The 3C value may be different.).
; The reason for this is to jump over the disk format information (the BPB and EBPB).
; Since the first sector of the disk is loaded into ram at location 0x0000:0x7c00 and executed, without this jump, the processor would attempt to execute data that isn't code.

; https://wiki.osdev.org/FAT

;
; FAT 12 header
;
jmp short start
nop

bdb_oem:                    db 'MSWIN4.1'    ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entires_count:      dw 0x00E0
bdb_total_sectors:          dw 2880         ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0xF0         ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9            ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0            ; 0x00 = floppy, 0x80 = hdd
ebr_reserved:               db 0            ; reserved
ebr_signature:              db 0x29
ebr_volume_id:              db 0x12, 0x34, 0x56, 0x78 ; serial number, values doesn't matter
ebr_volume_label:           db '           ' ; 11 byte label, padded with spaces
ebr_system_id:              db 'FAT12   '    ; 8 bytes, padded with spaces 

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

    ; read something from floppy disk
    ; BIOS should set DL to drive number
    mov [ebr_drive_number], dl

    mov ax, 12      ; LBA=1, second sector from disk
    mov cl, 1      ; Read 1 sector worth of data
    mov bx, 0x7e00 ; bx will contain the memory location where we want the data loading into.
    call disk_read
    
    ;print message
    mov si, message
    call puts

    ;display loaded data
    mov si, 0x7e00
    call puts

    cli
    hlt

floppy_error:
    mov si, message_read_failed
    call puts
    jmp wait_key_and_reboot

wait_key_and_reboot:
    mov ah, 0
    int 16h  ; wait for keypress
    jmp 0xffff:0    ; jump to beginning of BIOS, should reboot

.halt:
    cli
    hlt

;
; Disk routines
;

;
; Convert LBA address to CHS address
; Parameters:
;  - ax: LBA address
; Returns:
;   - cx [bits 0-5]: sector number
;   - cx [bits 6-15]: cylinder
;   - dh: head
lba_to_chs:

    push ax
    push dx

    xor dx, dx                          ; dx=0 - xor'ing anthing with itself returns 0.
    div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector
    
    xor dx, dx                          ; dx=0
    div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                         ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL

    pop ax
    mov dl, al                         ; restore DL
    pop ax
    ret

; Read sectors from disk
; Parameters
;  - ax: LBA address
;  - cl: number of sectors to read (up to 128)
;  - dl: drive number
;  - es:bx: memory address where to store read data

disk_read:

    push ax
    push bx
    push cx
    push dx
    push di


    push cx         ; save CL (number of sectors to read)
    call lba_to_chs ; compute CHS
    pop ax          ; AL = number of sectors to read

    mov ah, 0x2     ; Subroutine to read sectors from disk
    mov di, 3       ; for real world floppies, the read sometimes fails. We will try 3 times to read the data.

.retry:
    pusha           ; save all registers, we don't know which the bios modifies
    stc             ; set carry flag, some BIOS'es don't set it
    int 0x13        ; Perform read. If the carry flag is cleared then the read = sccess
    jnc .done       ; jump if carry not set

   ; read failed
    popa
    call disk_reset
    
    dec di 
    test di,di
    jnz .retry

.fail:
    ; all attempts to read the disk have failed
    jmp floppy_error


.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Reset disk controller
; Parameter:
;  dl: drive number
disk_reset:
    pusha
    mov ah, 0  ; routine to reset the disk
    stc
    int 13h
    jc floppy_error
    popa
    ret


message:             db "Bootloader running....." ,ENDLINE, 0
message_read_failed: db "Read from disk failed." ,ENDLINE, 0


times 510 - ($-$$) db 0
dw 0xaa55
