   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld a,$D6
   ld ($5800),a
   ret

; Deployment: Snapshot
   SAVESNA "load.sna", start
