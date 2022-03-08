   DEVICE ZXSPECTRUM48

   org $8000

; Routines
CL_ALL      = $0DAF

; Control Codes
TRUE_VIDEO  = $04
INV_VIDEO   = $05
ENTER       = $0D
INK         = $10
PAPER       = $11
FLASH       = $12
BRIGHT      = $13
GFX_0       = $80
UDG_0       = $90

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

udg4_bitmap:
   db %11111100
   db %11001100
   db %10001100
   db %10001100
   db %10011001
   db %00011001
   db %00011001
   db %00011001

udg5_bitmap:
   db %01100110
   db %11000110
   db %11000110
   db %11001100
   db %10001100
   db %10001100
   db %10011000
   db %11111000

udg6_bitmap:
   db %00000000
   db %00000000
   db %00000000
   db %00000000
   db %00000011
   db %00000000
   db %00000000
   db %00000000

udg7_bitmap:
   db %00011000
   db %00011000
   db %00010000
   db %00110000
   db %11100000
   db %00000000
   db %00000000
   db %00000000

start:
   im 1                 ; Use ROM-based interrupt routine
   ei                   ; Enable maskable interrupts
   call CL_ALL          ; Clear screen, reset cursor to top

; Deployment: Snapshot
   SAVESNA "graphics.sna", start
