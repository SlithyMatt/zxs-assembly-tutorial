   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld c,$0
   push bc
   pop af
   ld a,42
   ld b,57
   sub a,b  ; 42 - 57 = 241 + borrow (overflow)
   call printv
   sub a,b  ; 241 - 57 = 184
   call printv
   sub a,b  ; 21 + 220 = 190 + carry
   call printv
   ld b,42
   sub a,b  ; 190 + 42 = 232
   call printv
   ld b,128
   sub a,b  ; 232 + 128 = 104 + carry (overflow)
   call printv
   ld b,42
   sub a,b  ; 104 + 42 = 146 (overflow)
   call printv
   ld b,110
   sub a,b  ; 146 + 110 = 0 + carry
   call printv
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
