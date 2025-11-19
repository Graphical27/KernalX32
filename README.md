# KernalX32

> A tiny x86 bootloader + stage-2 loader (FAT12) + toy kernel — built for learning OSDev.

<p align="center">
  <img alt="status" src="https://img.shields.io/badge/status-experimental-f97316?style=for-the-badge&logo=github" />
  <img alt="arch" src="https://img.shields.io/badge/arch-x86%20real%20mode-8b5cf6?style=for-the-badge" />
  <img alt="lang-nasm" src="https://img.shields.io/badge/asm-NASM-0ea5e9?style=for-the-badge" />
  <img alt="lang-c" src="https://img.shields.io/badge/lang-C-22c55e?style=for-the-badge" />
  <img alt="emulator" src="https://img.shields.io/badge/runs%20on-Bochs%20%7C%20QEMU-ef4444?style=for-the-badge" />
</p>

---

## ✨ What it does

- Stage-1 boot sector (FAT12) written in NASM
  - Detects drive geometry via BIOS, reads the root directory, follows FAT12 cluster chains
  - Loads the Stage-2 binary from the floppy image
- Stage-2 (C + BIOS helpers)
  - Initializes disk and FAT12, lists a few root entries
  - Opens and prints the contents of `mydir/test.txt`
- Minimal 16-bit "kernel" example that prints a greeting via BIOS teletype and halts

> Goal: provide a simple, readable playground for learning real-mode booting, FAT12, and early loader design.

## 🧭 Project layout

```
KernalX32/
├─ Makefile                 # Builds bootloader, stage2, kernel, and a 1.44MB FAT12 floppy image
├─ bochs_config             # Example Bochs config (Linux)
├─ bochs_win_config         # Example Bochs config (Windows) – update paths before use
├─ src/
│  ├─ bootloader/
│  │  ├─ stage1/            # NASM boot sector (FAT12) that loads STAGE2  BIN
│  │  └─ stage2/            # C runtime: disk + FAT + simple I/O, prints a file
│  └─ kernel/               # Tiny 16-bit demo kernel (prints a message)
└─ build/                   # Output artifacts (created by make)
```

Key entry points:
- `src/bootloader/stage1/bootloader.asm` — FAT12 boot sector that loads Stage-2
- `src/bootloader/stage2/main.c` — FAT init, directory listing, and file printing
- `src/kernel/kernel.asm` — prints "Hello world from KERNEL!" and halts

## 🛠 Prerequisites

This project uses a GNU-ish toolchain to assemble, compile, and generate a FAT12 floppy image:

- NASM
- GCC (for the tiny C in Stage-2)
- make
- mtools (mkfs.fat, mcopy, mmd) and dd
- Bochs or QEMU to run

Windows-friendly options:
- Easiest: use WSL (Ubuntu) and install the above packages inside WSL, then run the build from the project folder mounted in WSL.
- Alternative: MSYS2 or Cygwin with nasm, gcc, make, coreutils, and mtools installed.

## 🚀 Build

- On Linux or WSL:

```bash
make
```

This produces `build/main_floppy.img` and supporting binaries:
- `build/stage1.bin`
- `build/stage2.bin`
- `build/kernel.bin`

## 🖥 Run it

### Bochs (Windows)

1. Open `bochs_win_config` and update the file paths to match your local installation and repo location.
   - Example: `floppya: 1_44="C:/Games/!Projects/KernalX32/build/main_floppy.img", status=inserted`
2. Launch Bochs with the config:

```powershell
bochs -f .\bochs_win_config
```

### Bochs (Linux/WSL)

```bash
bochs -f ./bochs_config
```

### QEMU (any platform)

```bash
qemu-system-i386 -fda build/main_floppy.img
```

You should see a loading message from the boot sector, Stage-2 listing a handful of root directory entries, and the contents of `mydir/test.txt` printed to the screen. The demo kernel prints a greeting and halts.

## 🧪 Quick demo (text)

```
Loading...
  .          ..         STAGE2  BIN
  KERNEL  BIN TEST     TXT       MYDIR     
Hello world from KERNEL!
<contents of mydir/test.txt>
```

Note: The exact directory names shown depend on what the image builder copies during `make`.

## 🔍 Tips & notes

- The top-level `Makefile` uses Unix-style tools (dd, mkfs.fat, mcopy, mmd). On Windows, prefer WSL or MSYS2.
- `bochs_win_config` ships with example BIOS ROM paths; point these to your installed Bochs directory.
- Stage-2 currently demonstrates FAT12 reads and basic printing; it’s a great spot to extend into loading a protected-mode kernel next.

## 🗺 Roadmap ideas

- Load a larger 32-bit (or 64-bit) kernel from Stage-2
- Basic memory map + GDT/IDT setup and interrupts
- Switch to protected mode and print via a simple VGA driver
- Add CI with artifact upload of the floppy image

## 🙌 Credits

- OSDev Wiki and community for fantastic documentation and references
- Various classic bootloader resources and blog posts

## 📜 License

No license file has been provided yet. If you plan to share or accept contributions, consider adding a LICENSE (MIT/Apache-2.0/BSD-2-Clause, etc.).
