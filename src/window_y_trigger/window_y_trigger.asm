include "common.asm"

Section "VBLANK ISR", ROM0[$40]
    ld a, 144
    ld [rWY], a
    reti

Section "STAT ISR", ROM0[$48]
    ; Return colors to normal after title bar
    ld a, 0
    ld [rWY], a
    reti

SECTION "Start", ROM0[$0100]
Entrypoint:
    nop
    jp main

    REPT $150 - $104
        db 0
    ENDR

SECTION "ROM", ROM0[$0150]
main:
    di
    ld sp, $FFFC

    call DisableLCD

    ; Zero fill WRAM
    ld d, 0
    ld bc, $2000
    ld hl, $C000
    call Memset

    ld d, 0
    ld bc, 32
    ld hl, $FF80
    call Memset

    ; Copy in font
    ld bc, 128 * 16 ; 16 bytes per tile
    ld de, Font
    ld hl, $9000
    call Memcpy

TestScreen:
    call DisableLCD

    ld de, MainText
    ld hl, $9800
    call StrcpyNoNullTilemapSmart

    ld de, FailText
    ld hl, $9D01
    call StrcpyNoNullTilemapSmart

    ld a, LCDCF_BGON | LCDCF_WINON | LCDCF_ON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_WIN9C00
    ld [rLCDC], a

    ld a, 7
    ld [rWX], a
    ld a, 0
    ld [rWY], a

    ld a, 56
    ld [rLYC], a

    ld a, STATF_LYC
    ld [rSTAT], a

    ld a, IEF_LCDC | IEF_VBLANK
    ld [rIE], a

    ei

.loop:
    jr .loop


SECTION "Font", ROMX
Font: INCBIN "src/window_y_trigger/ags-aging-font.chr"

SECTION "Text", ROMX
FailText:
    db " You should not be\n"
    db "  able to see this\n"
    db "  text.\n"
    db "\n"
    db "  Test failed.",0

MainText: 
    db "1 LY=WY Trigger Test\n"
    db "2\n"
    db "3 The numbers 1-18\n"
    db "4 should be visible\n"
    db "5 on the left side\n"
    db "6 of the screen.\n"
    db "7\n"
    db "8\n"
    db "9  If this text is\n"
    db "10 visible,the test\n"
    db "11 is OK!\n"
    db "12\n"
    db "13 Test OK!\n"
    db "14\n"
    db "15\n"
    db "16\n"
    db "17\n"
    db "18\n"
    db "19\n",0



