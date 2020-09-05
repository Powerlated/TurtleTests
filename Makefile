ASM=rgbasm -i src/common

gb = src/window_y_trigger/window_y_trigger.gb

all: $(gb)

ags-aging-font.chr:
	rgbgfx src/common/ags-aging-font.png -o src/common/ags-aging-font.chr

%.o: %.asm ags-aging-font.chr
	$(ASM) -o $@ $< 

$(gb): %.gb: %.o .FORCE
	rgblink -o $@ $<
	rgbfix -v -p 0 $@

# Always force a clean rebuild, this is Game Boy assembly, builds are fast.
.PHONY: .FORCE

.PHONY: clean
clean:
	rm GB/window_y_trigger/window_y_trigger.o
	rm GB/window_y_trigger/window_y_trigger.gb
	rm GB/common/ags-aging-font.chr

