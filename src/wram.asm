section "WRAM", wram0

CHARS_PER_LINE EQU 17

; The index of the current paragraph being drawn to the buffer. When all lines
; of a paragraph have been drawn, this number is incremented.
wCurrentParagraph
    ds 1

; The index of the current line being drawn to the buffer in the current
; paragraph. When this number reaches the total number of lines in the paragraph,
; it is reset to zero and the paragraph pointer is advanced.
wCurrentLineInParagraph
    ds 1

; The index of the character in the current line to be drawn next. When the drawing
; procedure encounters a null-terminator in the line, or when this value is >= 17,
; this index is reset to zero and the next line is started.
wCurrentCharInLine
    ds 1

; When this value is non-zero, the text is shifted up by one line to simulate
; scrolling. After a brief delay, this is set back to zero and the next line is drawn.
wShiftingToNextLine
    ds 1

; Stores BG map data for the current lines that should be draw to the
; screen during VBlank.
wTextBGMapDataShadowBuffer
    ds CHARS_PER_LINE * 2
