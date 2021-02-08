section "Timer Interrupt", rom0

BLANK_TILE_INDEX EQU $40 ; Blank tile

ConfigureInterrupts::
    ld a, TACF_START | TACF_4KHZ ; timer start @ 4 KHz speed
    ld [rTAC], a
    ld a, IEF_VBLANK | IEF_TIMER
    ld [rIE], a
    ld a, $80
    ld [rTMA], a ; by setting the TMA to half of a byte, we make the timer 8 KHz
    call SetupInitialStateForScript
    reti ; enable interrupt master flag

SetupInitialStateForScript::
    xor a
    ld [wCurrentCharInLine], a ; zero char in line
    ld [wCurrentLineInParagraph], a ; zero line in paragraph
    ld [wCurrentParagraph], a ; zero current paragraph
    ld [wShiftingToNextLine], a ; not currently shifting to next paragraph
    ld [wWaitingToAdvance], a ; not waiting to advance to next line
    ld [wCurrentCharInScript], a ; load zero for first byte of two-byte char in script

    ld a, [ScriptData] ; load first byte of script data, which is the line count of the first paragraph
    ld [wLineCountOfCurrentParagraph], a ; load line count into correct register
    ld a, 1
    ld [wCurrentCharInScript + 1], a ; load "1" for current char in script since we've read the line length

    ld hl, wTextBGMapDataShadowBuffer
    ld c, CHARS_PER_LINE * 2 ; counter at two lines
    ld a, BLANK_TILE_INDEX ; blank tile index
.loop
    ld [hli], a ; load the blank tile index into shadow buffer
    dec c
    jr nz, .loop
    ret

; Called by the timer interrupt vector
HandleTimer::
    push af
    push bc
    push de
    push hl

    ld a, [wWaitingToAdvance]
    and a ; check for zero
    jr nz, .finish ; if we're waiting to advance, skip to finish

    ld a, [wCurrentLineInParagraph]
    ld hl, wTextBGMapDataShadowBuffer
    and a
    jr z, .loadTileNumber ; skip if not line zero in paragraph
    ld de, CHARS_PER_LINE
    add hl, de ; move `hl` pointer to line two
.loadTileNumber
    ld a, [wCurrentCharInLine]
    ld c, a
    xor b ; `bc` contains the current offset in the line
    add hl, bc ; `hl` contains the offset in the shadow buffer to add the tile
    ld a, [wCurrentCharInScript]
    ld b, a
    ld a, [wCurrentCharInScript + 1]
    ld c, a ; `bc` contains offset of current char in script
    push hl ; preserve `hl` which contains the offset in shadow buffer
    ld hl, ScriptData
    add hl, bc
    inc bc
    ld a, b
    ld [wCurrentCharInScript], a
    ld a, c
    ld [wCurrentCharInScript + 1], a ; load incrememented char pointer back into RAM
    ld b, h
    ld c, l ; `bc` contains address of correct tile in script data
    pop hl
    ld a, [bc] ; `a` contains tile number for current char
    ld [hl], a ; load current tile number into shadow buffer

    ld a, [wCurrentCharInLine]
    inc a
    cp CHARS_PER_LINE
    jr nz, .loadCharInLine
    ld a, [wCurrentLineInParagraph]
    inc a
    ld [wCurrentLineInParagraph], a ; incremement current line in paragraph
    cp 2 ; sets carry flag is `a` < 2. If no carry, we should wait to advance
    jr c, .zeroAndLoadCharInLine
    ld hl, wWaitingToAdvance
    inc [hl] ; incremement waititng to advance if we have just drawn line 1 or greater
.zeroAndLoadCharInLine
    xor a
.loadCharInLine
    ld [wCurrentCharInLine], a ; will either be incremented by one, or will be zero if over CHAR_PER_LINE    
.finish
    pop hl
    pop de
    pop bc
    pop af
    reti
