from PIL import Image
import sys

def bitmapline(sourceline):
    return (sourceline & 0xC0) | ((sourceline & 0x38) >> 3) | ((sourceline & 0x07) << 3)

if len(sys.argv) < 2:
    print("Usage: python3 ", sys.argv[0], " [PNG filename] [starting screen line] [starting screen column]")
    sys.exit()

startline = 0
if len(sys.argv) >= 3:
    startline = int(sys.argv[2])

startcol = 0
if len(sys.argv) >= 4:
    startcol = int(sys.argv[3])

pngdata = Image.open(sys.argv[1])

if pngdata.format != "PNG":
    print("Error: ", pngdata.format, " format not supported, must be PNG")
    sys.exit();

if pngdata.mode != "P":
    print("Error: PNG must use 8-bit palette indexed color")
    sys.exit();

if ((pngdata.width+startcol) > 256) or ((pngdata.height+startline) > 192):
    print("Error: PNG must fit within 256x192 screen")
    sys.exit();

if (len(pngdata.palette.getdata()[1]) > 48):
    print("Error: PNG palette must be 16 colors or smaller")
    sys.exit();

colorpixels = pngdata.load();

attrrows = int(pngdata.height / 8)

if (startline % 8 != 0):
    print("Warning: startline is not divisible by 8, attributes may clash")
    attrrows = attrrows+1

if (pngdata.height % 8 != 0):
    print("Warning: image height is not divisible by 8, attributes may clash")
    if ((pngdata.height + startline) % 8 != 0):
        attrrows = attrrows+1

attributes = [[0 for y in range(attrrows)] for x in range(32)]

bmlines_start = startline
bmlines_stop = startline+pngdata.height
bmrows = range(bmlines_start,bmlines_stop)

for i in bmrows:
    line = bitmapline(i)
    if (line < bmlines_start):
        bmlines_start = line
    elif (line > bmlines_stop):
        bmlines_stop = line

attry_start = int(startline / 8)
bitmap = [[0 for y in range(bmlines_stop-bmlines_start)] for x in range(256)]

for x in range(pngdata.width):
    bitmapx = x+startcol
    attrx = int(bitmapx / 8)
    for y in range(pngdata.height):
        bitmapy = bitmapline(y+startline) - bmlines_start
        attry = int((y+startline) / 8) - attry_start
        isink = False
        if (x % 8 == 0) and ((y+startline) % 8 == 0):
            attributes[attrx][attry] = colorpixels[x,y] << 3
        elif (attributes[attrx][attry] & 0x07) == 0:
            bgcolor = attributes[attrx][attry] >> 3
            if colorpixels[x,y] != bgcolor:
                if ((colorpixels[x,y] ^ bgcolor) & 0x08) != 0:
                    print("Warning: brightness mismatch found at ", x, ",", y)
                fgcolor = colorpixels[x,y] & 0x07
                if (bgcolor & 0x07) != fgcolor:
                    isink = True
                    attributes[attrx][attry] = attributes[attrx][attry] | fgcolor
        else:
            bgcolor = (attributes[attrx][attry] >> 3) & 0x07
            fgcolor = attributes[attrx][attry] & 0x07
            pixelcolor = colorpixels[x,y] & 0x07
            if pixelcolor == fgcolor:
                isink = True
            elif pixelcolor != bgcolor:
                print("Warning: unexpected color found at ", x, ",", y, ", will be set as paper")
        bitmap[bitmapx][bitmapy] = 1 if isink else 0
        #print("colorpixels[",x,",",y,"] = ", colorpixels[x,y])
        #print("bitmap[",bitmapx,",",bitmapy,"] = ", bitmap[bitmapx][bitmapy])
        #print("attributes[",attrx,"][",attry,"] = ",attributes[attrx][attry])

bitmap_array = bytearray(len(bitmap[0])*32)
i = 0
for y in range(len(bitmap[0])):
    for x in range(32):
        octet = 0
        for pixel in range(8):
            bit = bitmap[x*8+pixel][y] << (7 - pixel)
            octet = octet | bit
        bitmap_array[i] = octet
        i = i+1
outfile = open("bitmap.bin","wb")
outfile.write(bitmap_array)

attr_array = bytearray(len(attributes[0])*32)
i = 0
for y in range(len(attributes[0])):
    for x in range(32):
        attr_array[i] = attributes[x][y]
        i = i+1
outfile = open("colors.bin","wb")
outfile.write(attr_array)
