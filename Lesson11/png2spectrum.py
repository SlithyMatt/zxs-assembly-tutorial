from PIL import Image
import sys

if len(sys.argv) < 2:
    print("Usage: python3 ", sys.argv[0], " [PNG filename] [starting screen line] [starting screen column]")
    sys.exit()

startline = 0
if len(sys.argv) >= 3:
    startline = int(sys.argv[2])

startcol = 0
if len(sys.argv) >= 4:
    startline = int(sys.argv[3])

pngdata = Image.open(sys.argv[1])

if pngdata.format != "PNG":
    print("Error: ", pngdata.format, " format not supported, must be PNG")
    sys.exit();

if pngdata.mode != "P":
    print("Error: PNG must use 8-bit palette indexed color")
    sys.exit();

if ((pngdata.width+startcol) > 256) or ((pngdata.height + startline) > 192):
    print("Error: PNG must fit within 256x192 screen")

print(pngdata.palette.getdata())
