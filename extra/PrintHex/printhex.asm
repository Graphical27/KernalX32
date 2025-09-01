org 0x7c00
bits 16

main:
    mov ax,0
    mov ss,ax
    mov ax, 0x1A3F
    xor cx,cx
    mov sp,0x7c00
    sti
    call printhex
    jmp halt

printhex:
    mov cx, 4
.next_digit:
    rol ax, 4
    mov dl, al
    and dl, 0x0F
    cmp dl, 9
    jbe .is_digit
    add dl, 'A' - 10
    jmp .print
.is_digit:
    add dl, '0'
.print:
    push ax
    mov ah, 0x0E
    mov al, dl
    mov bh,0
    int 0x10
    pop ax
    loop .next_digit
    ret
halt:
    cli

.hang:
    jmp .hang

times 510-($-$$) db 0
dw 0xaa55
