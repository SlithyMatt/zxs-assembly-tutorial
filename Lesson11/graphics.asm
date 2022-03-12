   DEVICE ZXSPECTRUM48

   org $8000

; Routines
CL_ALL      = $0DAF

; Control Codes
ENTER       = $0D
INK         = $10
PAPER       = $11
FLASH       = $12
BRIGHT      = $13
GFX_0       = $80
GFX_1       = GFX_0+1
GFX_2       = GFX_0+2
GFX_3       = GFX_0+3
GFX_4       = GFX_0+4
GFX_5       = GFX_0+5
GFX_6       = GFX_0+6
GFX_7       = GFX_0+7
GFX_8       = GFX_0+8
GFX_9       = GFX_0+9
GFX_A       = GFX_0+$A
GFX_B       = GFX_0+$B
GFX_C       = GFX_0+$C
GFX_D       = GFX_0+$D
GFX_E       = GFX_0+$E
GFX_F       = GFX_0+$F
UDG_0       = $90
UDG_1       = UDG_0+1
UDG_2       = UDG_0+2
UDG_3       = UDG_0+3
UDG_4       = UDG_0+4
UDG_5       = UDG_0+5
UDG_6       = UDG_0+6
UDG_7       = UDG_0+7
UDG_8       = UDG_0+8
UDG_9       = UDG_0+9
STOP        = $E2

; UDG
udg0_bitmap:
   db %00000000
   db %00000000
   db %00000000
   db %00001100
   db %00001100
   db %00011001
   db %00011001
   db %00011000

udg1_bitmap:
   db %00000000
   db %00000000
   db %00000000
   db %00000000
   db %00001100
   db %10011000
   db %10011000
   db %00011000

udg2_bitmap:
   db %00000000
   db %00000000
   db %00000000
   db %01111110
   db %01100000
   db %11000000
   db %11000000
   db %11000000

udg3_bitmap:
   db %00011111
   db %00110000
   db %00110000
   db %00111110
   db %00000011
   db %00000011
   db %00000110
   db %01111100

udg4_bitmap:
   db %00011001
   db %00110001
   db %00110011
   db %00110011
   db %00110011
   db %01100110
   db %01100110
   db %01100110

udg5_bitmap:
   db %10011100
   db %10110000
   db %00110001
   db %00110001
   db %00110001
   db %01100011
   db %01100011
   db %01110011

udg6_bitmap:
   db %11111100
   db %11001100
   db %10001100
   db %10001100
   db %10011001
   db %00011001
   db %00011001
   db %00011001

udg7_bitmap:
   db %01100110
   db %11000110
   db %11000110
   db %11001100
   db %10001100
   db %10001100
   db %10011000
   db %11111000

udg8_bitmap:
   db %00000000
   db %00000000
   db %00000000
   db %00000000
   db %00000011
   db %00000000
   db %00000000
   db %00000000

udg9_bitmap:
   db %00011000
   db %00011000
   db %00010000
   db %00110000
   db %11100000
   db %00000000
   db %00000000
   db %00000000

SIZE_UDG = $ - udg0_bitmap

banner:
   db BRIGHT,1,FLASH,0,PAPER,7,INK,4," ",UDG_0,UDG_1,UDG_2,"  ",BRIGHT,0,PAPER,2
   db "                      ",ENTER
   db BRIGHT,1,PAPER,7,UDG_3,UDG_4,UDG_5,UDG_6,UDG_7," ",BRIGHT,0,PAPER,2,INK,7," "
   db GFX_B,GFX_6,GFX_5,GFX_3,GFX_8,GFX_B,GFX_3,GFX_4,GFX_3,GFX_2,GFX_B
   db GFX_3,GFX_5,GFX_8,GFX_5,GFX_1,GFX_7,GFX_3,GFX_4,GFX_3,GFX_2,ENTER
   db BRIGHT,1,PAPER,7,INK,4,"   ",UDG_8,UDG_9," ",BRIGHT,0,PAPER,2,INK,7," "
   db GFX_B,GFX_2,GFX_5,GFX_3,GFX_8,GFX_B,GFX_2,GFX_0,GFX_3,GFX_8,GFX_B
   db GFX_2,GFX_5,GFX_7,GFX_D,GFX_0,GFX_5,GFX_0,GFX_0,GFX_3,GFX_8,ENTER
   db BRIGHT,1,PAPER,7,INK,0,"GAMES ",BRIGHT,0,PAPER,2,INK,7," "
   db GFX_A,GFX_0,GFX_5,GFX_0,GFX_A,GFX_E,GFX_C,GFX_4,GFX_C,GFX_2,GFX_E
   db GFX_C,GFX_5,GFX_0,GFX_7,GFX_0,GFX_5,GFX_0,GFX_4,GFX_C,GFX_2,ENTER
   db BRIGHT,1,PAPER,7,"      ",BRIGHT,0,PAPER,2
   db "                      ",ENTER,STOP

bitmap:
   INCBIN "bitmap.bin"

attributes:
   INCBIN "colors.bin"

BITMAP_START = $4800 ; start of pixel row 64 (top of character row 8)
BITMAP_SIZE = 2048   ; 256x64 (all of character rows 8-15)
ATTR_START = $5800 + 8*32
ATTR_SIZE = BITMAP_SIZE/8

FOOTER_START = $5000 ; start of pixel row 128 (top of character row 16)

UDG_START = $FF58

start:
   im 1                 ; Use ROM-based interrupt routine
   ei                   ; Enable maskable interrupts
   call CL_ALL          ; Clear screen, reset cursor to top
   ld hl,udg0_bitmap
   ld de,UDG_START
   ld bc,SIZE_UDG
   ldir                 ; overwrite UDGs with custom bitmaps
   ld hl,banner         ; Load address of start of banner string
banner_loop:
   ld a,(hl)            ; Get next character from banner
   cp STOP
   jr z,load_bitmap     ; if STOP, jump out of loop
   rst $10              ; print character
   inc hl               ; increment address
   jp banner_loop       ; continue loop
load_bitmap:
   ld hl,bitmap
   ld de,BITMAP_START
   ld bc,BITMAP_SIZE
   ldir                 ; copy bitmap to screen bitmap RAM
   ld hl,attributes
   ld de,ATTR_START
   ld bc,ATTR_SIZE
   ldir                 ; copy color attributes to screen attribute RAM
   ld hl,FOOTER_START   ; initialize with starting address of footer bitmap
   ld b,$ff             ; start end loop with all ink pixels
end_loop:
   halt                 ; wait for next video frame
   ld a,b               ; load pixels into A
   ld (hl),a            ; write pixels to screen bitmap RAM
   inc hl               ; go to next address
   bit 3,h              ; check to see if it puts us into attribute RAM
   jp z,end_loop        ; if still in bitmap RAM, continue loop
   ld hl,FOOTER_START   ; reset loop to top of footer again
   ld a,b
   xor $FF
   ld b,a               ; invert pixel pattern
   jp end_loop          ; continue loop with new pattern

; Deployment: Snapshot
   SAVESNA "graphics.sna", start
