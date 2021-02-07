section "Text box", rom0

CopyTextBoxBorderToBGMap::
    call CopyTextBoxCornersToBGMap
    call CopyTextBoxTopAndBottomLinesToBGMap
    call CopyTextBoxLeftAndRightLinesToBGMap
    ret

CopyTextBoxCornersToBGMap::
    ld hl, $9980 ; top-left corner
    xor a ; tile 0 is top-left tile
    ld [hl], a
    ld hl, $9993 ; top-right corner
    ld a, 2 ; tile 2 is top-right tile
    ld [hl], a
    ld hl, $9a20 ; bottom-left corner
    ld a, 4 ; tile 4 is bottom-left tile
    ld [hl], a
    ld hl, $9a33 ; bottom-right corner
    ld a, 5 ; tile 5 is bottom-right tile
    ld [hl], a
    ret

CopyTextBoxTopAndBottomLinesToBGMap::
    ld hl, $9981 ; leftmost BG address of top line
    call CopyHorizontalBorderLine
    ld hl, $9a21 ; leftmost BG address of bottom line
    jp CopyHorizontalBorderLine
    
CopyHorizontalBorderLine::
    ld b, 18 ; count of tiles in line
    ld a, 1 ; tile 1 is the horizontal border tile
.loop
    ld [hli], a
    dec b
    jr nz, .loop
    ret

CopyTextBoxLeftAndRightLinesToBGMap::
    ld hl, $99a0 ; top BG address of left vertical line
    call CopyVerticalBorderLine;
    ld hl, $99b3 ; top BG address of right vertical line
    call CopyVerticalBorderLine;
    ret

CopyVerticalBorderLine::
    ld b, 4 ; count of tiles in line
    ld a, 3 ; tile 3 is the vertical border tile
    ld de, $20 ; tiles per row to add to `hl` when looping
.loop
    ld [hl], a
    add hl, de
    dec b
    jr nz, .loop
    ret
