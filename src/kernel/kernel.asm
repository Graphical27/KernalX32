; kernel.asm intentionally left as a harmless 32-bit stub
; The actual kernel entry point is implemented in C (`start` in main.c).

bits 32
section .text
    ; no exported symbols here to avoid colliding with C 'start'
    nop