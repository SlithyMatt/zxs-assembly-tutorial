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
   sub a,b  ; 241 - 57 = 184 (H)
   call printv
   ld b,180
   sub a,b  ; 184 - 180 = 4 (overflow)
   call printv
   sub a,b  ; 4 - 180 = 80 + borrow
   call printv
   sub a,b  ; 80 - 180 = 156 + borrow (H)
   call printv
   sub a,b  ; 156 - 180 = 232 + borrow
   call printv
   ld b,232
   sub a,b  ; 232 - 232 = 0
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
