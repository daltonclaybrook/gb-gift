section "Text", rom0

; This data block is chunked into paragraphs. Each paragraph begins with one byte
; indicating the count of lines in the paragraph. This byte is folowed by
; 17 * n bytes were `n` is the count of lines in the paragraph.
ScriptData::
    incbin "script.bin"
ScriptDataEnd::
