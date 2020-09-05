ASM=rgbasm -i src/common

all: src/window_y_trigger/window_y_trigger.gb

src/window_y_trigger/window_y_trigger.gb: .FORCE
	rgbgfx src/window_y_trigger/ags-aging-font.png -o src/window_y_trigger/ags-aging-font.chr
	$(ASM) src/window_y_trigger/window_y_trigger.asm -o src/window_y_trigger/window_y_trigger.o
	rgblink src/window_y_trigger/window_y_trigger.o -o src/window_y_trigger/window_y_trigger.gb
	rgbfix -v -p 0 src/window_y_trigger/window_y_trigger.gb

# Always force a clean rebuild, this is Game Boy assembly, builds are fast.
.PHONY: .FORCE

clean:
	rm GB/CTF/ctf.o
	rm GB/CTF/ctf.gb
	rm GB/CTF/ags-aging-font.chr

