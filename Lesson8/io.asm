   DEVICE ZXSPECTRUM48

   org $8000

start:
   ld bc,$FEFE          ; BC = Port $FEFE (in: keyboard[Shift,Z,X,C,V]; out: beeper)
   ld d,0               ; D = byte to output (bit 4 toggled for beeper frequency)
.keyloop:
   in a,(c)             ; A = key states
   bit 2,a              ; Check bit 2 (X key)
   jp nz,.soundoff      ; If bit is set, key is not pressed, turn off sound
   ld a,d               ; A = last output byte
   xor $10              ; flip bit 4
   ld d,a               ; save new byte back to D
   jp .output
.soundoff:
   ld a,0               ; hold output to zero
.output:
   out (c),a            ; output determined byte value
   .500 nop             ; do a busy wait (2000 T-states = 0.57 ms)
   jp .keyloop          ; loop indefinitely

; Deployment: Snapshot
   SAVESNA "io.sna", start
