ASM=rgbasm -i src/common

all: src/window_y_trigger/window_y_trigger.gb

ags-aging-font.chr:
	rgbgfx src/common/ags-aging-font.png -o src/common/ags-aging-font.chr

src/window_y_trigger/window_y_trigger.gb: ags-aging-font.chr .FORCE
	$(ASM) src/window_y_trigger/window_y_trigger.asm -o src/window_y_trigger/window_y_trigger.o
	rgblink src/window_y_trigger/window_y_trigger.o -o src/window_y_trigger/window_y_trigger.gb
	rgbfix -v -p 0 src/window_y_trigger/window_y_trigger.gb

# Always force a clean rebuild, this is Game Boy assembly, builds are fast.
.PHONY: .FORCE

clean:
	rm GB/window_y_trigger/window_y_trigger.o
	rm GB/window_y_trigger/window_y_trigger.gb
	rm GB/common/ags-aging-font.chr

