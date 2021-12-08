   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld a,$FE
   in a,($FE)
   ld bc,$FDFE
   in d,(c)
   ld b,$FB
   in e,(c)
   ld b,$F7
   in h,(c)
   ld b,$EF
   in l,(c)
   ld b,h
   ld c,l
   exx
   ld bc,$DFFE
   in d,(c)
   ld b,$BF
   in e,(c)
   ld b,$7F
   in h,(c)
   ld b,h
   ld c,a
   jp start

   ; B = SPACE, SYM SHFT, M, N, B
   ; C = SHIFT, Z, X, C, V
   ; D = P, O, I, U, Y
   ; E = ENTER, L, K, J, H
   ; B' =  1, 2, 3, 4, 5
   ; C' = 0, 9, 8, 7, 6
   ; D' =  A, S, D, F, G
   ; E' =  Q, W, E, R, T

   ret

; Deployment: Snapshot
   SAVESNA "kb.sna", start
