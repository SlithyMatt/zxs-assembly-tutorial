#!/bin/sh
python3 -m pip install Pillow
python3 png2spectrum.py bitmap.png 64
sjasmplus --lst graphics.asm
