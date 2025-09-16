; BIOS = Basic Input Output System
org 0x7c00
bits 16

mesg_hello db 'Hello, World!',0
;db = define byte
main:
    mov ax,0
    mov ds,ax
    ; mov es,ax

    mov ss,ax
    mov sp,0x7c00
    mov si,mesg_hello
    call puts
    hlt

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
    pop si
    pop ax        ;THe repition was happening case i poped ax before si
    ret

.halt:
    jmp .halt
times 510-($-$$) db 0
dw 0xaa55
;dw = define word