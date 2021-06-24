   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld a,%11001100
   ld de,$4000
   ld (de),a
   ex de,hl
   ld de,$4001
   ld bc,$200
bitmap_loop:
   ldi               ; fill first 16 rows with vertical bars
   ld a,b
   or c
   jr nz,bitmap_loop
   srl (hl)          ; shift pattern to right
   ld bc,$200
   ldir              ; fill the next 16 rows with shifted bars
   srl (hl)          ; shift pattern to right once more
   ld de,$45FF
   ldd               ; copy new pattern to end of next block, decrement DE
   ld bc,$1FE
   ld hl,$45FF
   lddr              ; fill in third block backwards
   ld hl,$4600
   ld (hl),%10011001
   ld de,$4601
   ld bc,$1FF
   exx               ; we'll get back to the fourth block later
   ld hl,$5800
   ld (hl),$41       ; blue ink on black paper
   ld de,$5801
   ld bc,$FF
color_loop:
   ldi
   inc (hl)          ; increment ink color
   ld a,$07
   and (hl)          ; check to see if ink set to zero (black)
   jr nz,next
   ld (hl),$41       ; re-initialize color
next:
   ld a,b
   or c
   jr nz,color_loop
   exx               ; bring back fourth block addresses
   ldir              ; fill in fourth block
   ret

; Deployment: Snapshot
   SAVESNA "data.sna", start
