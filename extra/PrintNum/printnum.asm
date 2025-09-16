org 0x7c00
bits 16

numer: dw 1234
main:
    xor ax,ax
    mov ss,ax
    mov sp,0x7c00
    mov ax, [numer]
    
    call printnum
    jmp halt
printnum:
    mov bx,10
    mov dx,0
    xor cx,cx
.loop:
    xor dx,dx
    div bx ;divide ax by bx, quotient in ax, remainder in dx
    inc cx 
    push dx
    test ax,ax
    jnz .loop
    
.print:
    pop dx
    add dl,'0'
    mov al,dl
    mov ah,0x0e
    mov bh,0
    int 0x10
    dec cx
    jnz .print
    ret

halt:
    cli

.hang:
    jmp .hang

times 510-($-$$) db 0
dw 0xaa55


