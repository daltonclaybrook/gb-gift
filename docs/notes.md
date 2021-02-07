## Text storage and display strategy

BG map pointers to tiles are stored in a shadow RAM buffer. The size of this buffer is 17 * 2 bytes: There are 17 characters in a line of text, and two lines of text visible at any given moment.

Text can be shifted upwards by one tile in the BG map to simulate scrolling. This shifted state is stored in a single byte register in RAM. When the register is non-zero, text is rendered one tile higher than the normal idle state. This occurs only very briefly as the next line is about to be displayed.

Text is stored in cartridge ROM as lines and paragraphs. A line must be 17 characters or shorter, and a paragraph must be 255 (1 byte) lines or fewer (It may turn out that a paragraph must be at least two lines...). The ROM text data is packed using the following structure:

- 0: number of lines
- 1..17: ASCII bytes of first line with null-terminator (0). If the line is exactly 17 characters long, no null-terminator is used.
- 18..34: ASCII bytes of second line...
- ...
- [num_lines * 17 - 17 + 1]...[num_lines * 17]: ASCII bytes of last line.

BG map tile pointers are copied from shadow buffer to VRAM during each VBlank pass. This procedure is mostly a simple copy, but it checks the line shift register to know which line to start copying text tiles to.

Procedure for populating shadow buffer:

- Timer interrupt fires each time a new letter should be written to the screen. (If the slowest timer is still too fast, we can decrement a memory register instead and write a letter when this register reaches zero.)
- 
