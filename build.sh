#!/bin/bash

NAME=gift
TITLE=GIFT

# exit on error
set -e

for image_file in images/*.png; do
    [ -e "$image_file" ] || continue
    stripped_ext=${image_file%.png}
    output=${stripped_ext}.2bpp
    rgbgfx -o ${output} ${image_file}
done

# must cd into src directory because the include paths are relative to this directory
cd src
rgbasm -v -o ../build/main.o main.asm
rgblink -d -n ../build/${NAME}.sym -o ../build/${NAME}.gb ../build/main.o
rgbfix -cjsv -k 01 -l 0x33 -m 0x1b -p 0 -r 03 -t ${TITLE} ../build/${NAME}.gb
