include "hardware.inc"

SECTION "Common", ROMX, BANK[1]

; Safely disables the LCD.
DisableLCD:
    ; If the LCDC is already disabled, return.
    ld a, [rLCDC]
    and a, %10000000
    ret z
.loop:

    ld a, [rLY]
    cp $90 ; Check if the LCD is past VBlank
    jr nz, .loop

    xor a
    ld [rLCDC], a
    ret

; Copies until null terminator is hit, including the null terminator
; @param DE: Source Pointer
; @param HL: Destination Pointer
Strcpy:
    ld a, [de]
    ld [hl+], a

    or a ; Check for null terminator
    ret z

    inc de
    
    jr Strcpy

; Copies until null terminator is hit, excluding the null terminator
; @param DE: Source Pointer
; @param HL: Destination Pointer
StrcpyNoNull:
    ld a, [de]

    or a ; Check for null terminator
    ret z

    ld [hl+], a

    inc de
    
    jr StrcpyNoNull

; Smart copy to tilemap until null terminator is hit, excluding the null terminator
; @param DE: Source Pointer
; @param HL: Destination Pointer
StrcpyNoNullTilemapSmart:
    ld bc, 32
.loop:
    ld a, [de]

    or a ; Check for null terminator

    ret z
    cp a, $A ; Detect newline character
    jr z, .newline

    ld [hl+], a
    inc de

    jr .loop
.newline:
    add hl, bc
    ld a, l

    ; Reset to the left of the tilemap
    and a, %11100000
    ld l, a

    inc de

    jr .loop

; Copies memory
; @param BC: Bytes to copy
; @param DE: Source Pointer
; @param HL: Destination Pointer
Memcpy:
    ld a, [de]
    ld [hl+], a

    inc de
    dec bc

    ld a, b
    or a
    jr nz, Memcpy
    ld a, c
    or a
    jr nz, Memcpy
    ret

; Sets a block of memory to a value
; BC: Bytes to copy
; HL: Pointer to destination
; D: Byte to set with
Memset:
    ld a, d
    ld [hl+], a

    dec bc

    ld a, b
    or a
    jr nz, Memset
    ld a, c
    or a
    jr nz, Memset
    ret
