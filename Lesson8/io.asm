   DEVICE ZXSPECTRUM48

   org $8000

   jp start

   ; ROM routines
ROM_CLS     = $0DAF
ROM_PRINT   = $203C

start:
   exx
   push hl              ; preserve HL'

   ; demo instructions: in, out, ind, indr, ini, inir, outd, otdr, outi, otir

   ld bc,$FEFE
   ld d,0
.keyloop:
   in a,(c)
   bit 2,a
   jp nz,.soundoff
.soundon:
   ld a,d
   xor $10
   ld d,a
   jp .output
.soundoff:
   ld a,0
.output:
   out (c),a
   .500 nop
   jp .keyloop

   pop hl
   exx               ; restore HL' to gracefully return to BASIC
   ret



; Deployment: Snapshot
   SAVESNA "io.sna", start
