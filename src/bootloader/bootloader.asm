; BIOS = Basic Input Output System
org 0x7c00
bits 16

%define ENDL 0Dh,0Ah

;FAT 12

jmp short start
nop

bdb_oem db 'MSWIN4.1'
bdb_bytes_per_sector dw 512
bdb_sectors_per_cluster db 1
bdb_reserved_sectors dw 1
bdb_fat_count db 2
bdb_dir_entries dw 0e0h
bdb_total_sectors dw 2880
bdb_media_descriptor db 0xf0
bdb_sectors_per_fat dw 9
bdb_sectors_per_track dw 18
bdb_head_count dw 2
bdb_hidden_sectors dd 0
bdb_large_sectors dd 0

;extended boot record
ebr_drive_number db 0
ebr_reserved db 0
             db 0
ebr_signature db 0x29
ebr_volume_id dd 0x12345678
ebr_volume_label db 'NO NAME    '
ebe_system_id db 'FAT12   '



;db = define byte
start:
    call main
main:
    mov ax,0
    mov ds,ax
    mov es,ax

    mov ss,ax
    mov sp,0x7c00

    ; read something from floppy disk 
    ; BIOS should set DL to drive

    mov [ebr_drive_number], dl
    mov ax,1                 ; LBA address = 1
    mov cl,1                 ; read 1 sector
    mov [sector_count], cl   ; save sector count
    mov bx,0x7e00            ; buffer to store data
    call disk_read
    mov si,mesg_hello
    call puts
    jmp halt

puts:
    push si
    push ax
.loop:
    lodsb
    cmp al,0
    je .done
    mov ah,0x0e
    mov bh,0
    int 0x10
    jmp .loop
.done:
    pop ax
    pop si
    ret

; Disk Routines

; 1> Convert LBA to CHS
; 2> Parameter:
;       - ax: LBA address
;Returns:
;       - cx: [bits 0-5]: sector number
;             [bits 6-15]: cylinder number
;       - dh: head number

lba_to_chs:
    push ax
    push dx
    xor dx,dx
    div word [bdb_sectors_per_track] ; ax =  LBA / sectors per track, dx = LBA % sectors per track
                                     ; dx = LBA % sectors per track = sector number
    inc dx     ; dx = LBA % sectors per track + 1 = sector number (1-18)
    mov cx,dx

    xor dx,dx
    div word [bdb_head_count] ; ax = (LBA / sectors per track) / heads per cylinder
                              ; dx = (LBA / sectors per track) % heads per cylinder = head numbe
    mov dh,dl                 ; dh = head number
    mov ch,al                 ; ch = cylinder number (low 8 bits)
    shl ah,6 
    or cl,ah

    pop dx
    pop ax
    ret

; Reads sectors from disk
; Parameters:
;   - ax: LBA address
;   - cl: number of sectors to read
;   - dl: drive number
;   - es:bx: buffer to store data

floppy_error:
    mov si,mes_read_failed
    call puts
    jmp wait_key_and_reboot
wait_key_and_reboot:
    mov ah,0
    int 16h   ;wait for key press
    jmp 0FFFFh:0
    hlt

disk_read:
    push ax
    push bx
    push cx
    push dx
    push di
    call lba_to_chs             ; sets CX and DH from AX (LBA)
    mov ah, 02h                 ; BIOS read sectors
    mov al, [sector_count]      ; sector count
    mov dl, [ebr_drive_number]  ; drive number
    mov di, 3                   ; retry count
.retry:
    pusha
    stc
    int 13h
    jnc .done
    popa
    call disk_reset
    dec di
    jnz .retry
    jmp floppy_error

.done:
    popa
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Reset the disk system
;  Parameters:
;    - dl: drive number

disk_reset:
    pusha
    mov ah,0
    stc
    int 13h
    jc floppy_error
    popa
    ret


halt:
    cli

.hang:
    jmp .hang

mesg_hello db 'Hello, World!',0
mes_read_failed: db 'Read Failed!',ENDL,0
sector_count db 0
times 510-($-$$) db 0
dw 0xaa55
;dw = define word