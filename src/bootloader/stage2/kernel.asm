; kernel.asm removed from stage2 build: file previously defined 'entry' and called _cstart_
; This file conflicted with `entry.asm` in the same directory and caused multiple-definition linker errors.
; Keeping an empty stub so builds that expect this file name won't fail.
bits 16