section "Common", rom0

; Copy data from some source to some destination
; @param de - pointer to the source address
; @param hl - pointer to the destination address
; @param bc - count of bytes to transfer
CopyData::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c ; if bc is zero, the zero flag will be set by this call
    jr nz, CopyData
    ret
