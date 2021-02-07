section "Timer Interrupt", rom0

ConfigureInterrupts::
    ld a, TACF_START | TACF_4KHZ ; timer start @ 4 KHz speed
    ld [rTAC], a
    ld a, IEF_VBLANK | IEF_TIMER
    ld [rIE], a
    call TestShadowBuffer
    reti ; enable interrupt master flag

;; This is just a test and should be removed
TestShadowBuffer::
    ld hl, wTextBGMapDataShadowBuffer
    ld de, ExampleString
    ld c, ExampleStringEnd - ExampleString
.nextChar
    ld a, [de]
    ld [hli], a
    inc de
    dec c
    jr nz, .nextChar
    ret

; Called by the timer interrupt vector
HandleTimer::
    reti
