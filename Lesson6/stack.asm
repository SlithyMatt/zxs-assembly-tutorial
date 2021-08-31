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
   ; include instructions: ret, call, push, rst, pop (exclude reti, retn)
   ; specific opcodes: ld sp,xx; inc sp; add hl,sp; add ix,sp; add iy,sp
   ;                   dec sp; ex (sp),hl; ex (sp),ix; ex (sp),iy
   ;                   ld sp,hl; ld sp,ix; ld sp,iy; sbc hl,sp; ld (xx),sp
   ;                   adc hl,sp; ld sp,(xx)
   exx
   push hl              ; preserve HL'

   ; make stripes
   ld ix,SCREEN_BITMAP  ; start at beginning of screen memory
   ld hl,$FF00          ; 16-pixel pattern
   ld bc,BITMAP_SIZE/2  ; whole screen
   call fill_ram        ; fill in pixel data
   ld ix,SCREEN_COLOR   ; start at beginning of color attribute memory
   ld hl,$2A2A          ; red on cyan for 2 squares
   ld bc,COLOR_SIZE/2   ; whole screen
   call fill_ram        ; fill in color attributes

   pop hl
   exx                  ; restore HL' to gracefully return to BASIC
   ret

fill_ram:   ; IX = RAM address
            ; BC = number of words
            ; HL = word to write
   ld (sp_backup),sp    ; back up the stack pointer
   add ix,bc
   add ix,bc            ; IX = address after target segment
   ld sp,ix             ; make the RAM the stack
   ld a,$FF
.loop:
   push hl              ; write pattern
   dec c                ; decrement loop index
   jp nz,.loop
   dec b                ; lower byte wrapped around, decrement upper byte
   cp b                 ; check for underflow
   jp nz,.loop
   ld sp,(sp_backup)    ; restore stack pointer
   ret

; Deployment: Snapshot
   SAVESNA "stack.sna", start
