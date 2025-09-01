ASM=nasm
SRC=printhex.asm
BUILD_DIR=build

$(BUILD_DIR)/printhex_floppy.img: $(BUILD_DIR)/printhex.bin
	cp $(BUILD_DIR)/printhex.bin $(BUILD_DIR)/printhex_floppy.img
	truncate -s 1440K $(BUILD_DIR)/printhex_floppy.img

$(BUILD_DIR)/printhex.bin: $(SRC)
	$(ASM) $(SRC) -f bin -o $(BUILD_DIR)/printhex.bin

# clean:
# 	rm -f $(BUILD_DIR)/printhex.bin $(BUILD_DIR)/printhex_floppy.img