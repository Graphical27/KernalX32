org 0x7C00
bits 16

%define ENDL 0x00, 0x0A

start:
    jmp main

puts:
    push si
    push ax

.loop:
    lodsb                   ; load byte at DS:SI into AL, increment SI
    or al, al               ; check if null terminator
    jz .done

    mov ah, 0x0E            ; BIOS teletype output function
    mov bh, 0               ; page number
    int 0x10                ; call BIOS interrupt to print char

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov si, msg_hello
    call puts

    hlt
.halt:
    jmp .halt

msg_hello: db 'Hello World!', ENDL, 0

times 510 - ($ - $$) db 0
dw 0xAA55
