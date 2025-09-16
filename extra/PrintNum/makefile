ASM=nasm
SRC=printnum.asm
BUILD_DIR=build

$(BUILD_DIR)/printnum_floppy.img: $(BUILD_DIR)/printnum.bin
	cp $(BUILD_DIR)/printnum.bin $(BUILD_DIR)/printnum_floppy.img
	truncate -s 1440K $(BUILD_DIR)/printnum_floppy.img

$(BUILD_DIR)/printnum.bin: $(SRC)
	$(ASM) $(SRC) -f bin -o $(BUILD_DIR)/printnum.bin

# clean:
# 	rm -f $(BUILD_DIR)/printnum.bin $(BUILD_DIR)/printnum_floppy.img