org 0x7c00
use16


define ENDLINE 0x0d, 0x0a


; This creats a bootable floppy disk with and included FAT 12 header.
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

    ;print message
    mov si, message
    call puts
    
    hlt

message:
    db "Hello world" ,0xa,0xd, 0


times 510 - ($-$$) db 0
dw 0xaa55
