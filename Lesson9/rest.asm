   DEVICE ZXSPECTRUM48

   org $8000

   jp start

   ; ROM routines
ROM_CLS     = $0DAF
ROM_PRINT   = $203C

start:
   exx
   push hl              ; preserve HL'

   ; demo instructions: nop, daa, halt, di, ei, im, cpi, cpir
   ;                    cpd, cpdr


   pop hl
   exx               ; restore HL' to gracefully return to BASIC
   ret



; Deployment: Snapshot
   SAVESNA "bit.sna", start
