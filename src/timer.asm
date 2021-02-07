section "Timer Interrupt", rom0

BLANK_TILE_INDEX EQU $40 ; Blank tile

ConfigureInterrupts::
    ld a, TACF_START | TACF_4KHZ ; timer start @ 4 KHz speed
    ld [rTAC], a
    ld a, IEF_VBLANK | IEF_TIMER
    ld [rIE], a
    ld a, $80
    ld [rTMA], a ; by setting the TMA to half of a byte, we make the timer 8 KHz
    call SetupInitialStateOfShadowBuffer
    reti ; enable interrupt master flag

SetupInitialStateOfShadowBuffer::
    xor a
    ld [wCurrentCharInLine], a ; set current character in line to zero
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
    ld a, [wCurrentCharInLine]
    cp ExampleStringEnd - ExampleString ; stop copying if we're at the end of the string
    jr z, .finish
    ld hl, ExampleString
    ld c, a ; load current offset into `c`
    xor b ; `bc` now contains current offset
    inc a
    ld [wCurrentCharInLine], a ; load next char number in register
    add hl, bc ; add current offset to hl
    ld d, h 
    ld e, l ; `de` contains current offset in string
    ld hl, wTextBGMapDataShadowBuffer
    add hl, bc ; `hl` contains shadow buffer offset by current position
    ld a, [de]
    ld [hl], a ; load next tile into shadow buffer
.finish
    reti
