   DEVICE ZXSPECTRUM48

   org $8000

start:
   ei
   ld c,$fe
sound_loop:
   xor $10
   halt
   out (c),a
   jp sound_loop

; Deployment: Snapshot
   SAVESNA "sound.sna", start
