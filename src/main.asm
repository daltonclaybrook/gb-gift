include "../include/hardware.inc" ; https://github.com/gbdev/hardware.inc
include "macros.asm"
include "constants.asm"
include "common.asm"
include "text_box.asm"

;; Interrupts

section "VBlank", rom0[$40]
    reti
section "LCD Status", rom0[$48]
    reti
section "Timer", rom0[$50]
    reti
section "Serial", rom0[$58]
    reti
section "Joypad", rom0[$60]
    reti

section "Header", rom0[$100]

; Execution always begins at $100, but the header starts at $104
; so we need to jump quickly to another location.
EntryPoint::
    nop
    jp Start
    
    ; The cartridge header is located here, which contains things like
    ; the game title, Nintendo logo, and GBC support flag.
    ; This instruction fills this space with zeros, and the `rgbfix` 
    ; program will overwrite with the correct values later.
    ds $150 - $104

section "Main", rom0[$150]

Start::
    call DisableLCD
    call LoadDMGPalette
    call SelectBGTileData
    call CopyFontToVRAM
    call CopyTextBoxToVRAM
    call ClearBGMap
    call CopyTextBoxBorderToBGMap
    call EnableLCD
.gameLoop
    halt
    jr .gameLoop

DisableLCD::
    ld b, SCRN_Y
.loop
    ld a, [rLY]
    cp b
    jr nz, .loop
    ld hl, rLCDC
    res LCD_ON_BIT, [hl]
    ret

EnableLCD::
    ld hl, rLCDC
    set LCD_ON_BIT, [hl]
    ret

CopyFontToVRAM::
    ld hl, _VRAM8800 ; destination
    ld de, Font ; source
    ld bc, FontEnd - Font ; count to transfer
    jp CopyData

CopyTextBoxToVRAM::
    ld hl, _VRAM9000
    ld de, TextBox
    ld bc, TextBoxEnd - TextBox
    jp CopyData

LoadDMGPalette::
    ld a, %11100100 ; white, light gray, dark gray, black
    ld [rBGP], a
    ret

; Set BG tile data to use $8800-$97ff
SelectBGTileData::
    ld a, [rLCDC]
    res 4, a ; unset bit 4 for correct tile data range
    ld [rLCDC], a
    ret

; Set the BG map to blank tiles
ClearBGMap::
    ld hl, _SCRN0 ; BG map address
    ld bc, _SCRN1 - _SCRN0 ; full byte length of BG map
    ld d, $10 ; blank tile number
.loop
    ld [hl], d
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .loop
    ret

Font::
    incbin "../images/font.2bpp"
FontEnd::

TextBox::
    incbin "../images/text_box.2bpp"
TextBoxEnd::
