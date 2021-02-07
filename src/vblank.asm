section "VBlank Interrupt", rom0

LINE_1_BG_ADDRESS EQU $99c1

HandleVBlank::
    push af
    push bc
    push de
    push hl

    ld de, wTextBGMapDataShadowBuffer
    ld hl, LINE_1_BG_ADDRESS
    ld b, 2 ; number of lines of text to draw
.nextLine
    ld c, CHARS_PER_LINE
.nextChar
    ld a, [de] ; fetch next tile index in buffer
    ld [hli], a ; load tile index into BG map
    inc de
    dec c
    jr nz, .nextChar ; loop if not does with this line
    dec b
    jr z, .finish ; finish if we've drawn both lines
    push de
    ld de, $40 - CHARS_PER_LINE ; skip two BG lines minus characters already drawn
    add hl, de
    pop de
    jr .nextLine

.finish
    pop hl
    pop de
    pop bc
    pop af
    reti
