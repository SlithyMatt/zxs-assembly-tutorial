   DEVICE ZXSPECTRUM48

   org $8000

   jp start

SCREEN_BITMAP  = $4000
BITMAP_SIZE    = $1800
SCREEN_COLOR   = $5800
COLOR_SIZE     = $0300

sp_backup:
   dw 0

start:
   exx
   push hl              ; preserve HL'

   ; make stripes
   ld hl,SCREEN_BITMAP  ; start at beginning of screen memory
   ld de,$FF00          ; 16-pixel pattern
   ld bc,BITMAP_SIZE/2  ; whole screen
   call fill_ram        ; fill in pixel data

   ld hl,SCREEN_COLOR   ; start at beginning of color attribute memory
   ld de,$2A2A          ; red on cyan for 2 squares
   ld bc,COLOR_SIZE/2   ; whole screen
   call fill_ram        ; fill in color attributes

   pop hl
   exx                  ; restore HL' to gracefully return to BASIC
   ret

fill_ram:   ; HL = RAM address
            ; BC = number of words
            ; DE = word to write
   ld (sp_backup),sp    ; back up the stack pointer
   add hl,bc
   add hl,bc            ; HL = address after target segment
   ld sp,hl             ; make the RAM the stack
   ld a,$FF
.loop:
   push de              ; write pattern
   dec c                ; decrement loop index
   jp nz,.loop
   dec b                ; lower byte wrapped around, decrement upper byte
   cp b                 ; check for underflow
   jp nz,.loop
   ld sp,(sp_backup)    ; restore stack pointer
   ret

; Deployment: Snapshot
   SAVESNA "stack.sna", start
