   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld c,$00
   push bc
   pop af
   ld hl,$1234
   ld de,$5678
   add hl,de ; HL = $68AC
   ld de,$8000
   sbc hl,de ; HL = $E8AC + carry (overflow)
   ccf
   sbc hl,hl
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
