section "Avatar", rom0

AVATAR_WIDTH EQU 7
AVATAR_HEIGHT EQU 7
AVATAR_FIRST_TILE_NUM EQU 6

CopyAvatarToBGMap::
    ld a, AVATAR_FIRST_TILE_NUM ; first tile number of avatar in VRAM
    ld hl, $9886 ; top-left corner of avatar in BG map
    ld de, $20 - AVATAR_WIDTH ; added to `hl` to jump to next line when drawing avatar
    ld c, AVATAR_HEIGHT
.startNextLine
    ld b, AVATAR_WIDTH
.nextTileInLine
    ld [hli], a
    inc a
    dec b
    jr nz, .nextTileInLine
    add hl, de
    dec c
    jr nz, .startNextLine
    ret
