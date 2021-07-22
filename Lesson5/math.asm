   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld c,$00
   push bc
   pop af
   ld hl,$1234
   ld de,$5678
   add hl,de ; HL = $68AC
   ld c,$ff
   push bc
   pop af
   add hl,de ; HL = $BF24 (overflow?)
   ld hl,$9ABC
   add hl,de ; HL = $F134
   ld de,$1234
   add hl,de ; HL = $0368 + carry
   ld de,$89AB
   ld hl,$CDEF
   add hl,de ; HL = $579A + carry (overflow?)
   ld de,$A866
   add hl,de ; HL = 0
   ret

printv:
   push af
   push bc
   jp pe,vset
   ld a,$30
   jp printv_doit
vset:
   ld a,$31
printv_doit:
   rst $10
   pop bc
   pop af
   ret

; Deployment: Snapshot
   SAVESNA "math.sna", start
