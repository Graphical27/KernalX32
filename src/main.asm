; BIOS == Basic Input Output System

org 0x7C00
bits 16

%define ENDL 0x0D,0x0A
msg_hello: db 'Hello World!', 0
;db = declare byte

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    mov si, msg_hello
    call puts
    hlt
puts:
    push si
    push ax
.loop:
    lodsb  ;load next char in al
    cmp al, 0
    je .done
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp .loop

.done:
    pop si
    pop ax
    ret

.hatl:
    jmp .hatl

times 510-($-$$) db 0
dw 0AA55h
;dw = declare word (2 bytes)