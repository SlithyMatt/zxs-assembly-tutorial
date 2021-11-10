   DEVICE ZXSPECTRUM48

   org $8000

   jp start

   ; ROM routines
ROM_CLS     = $0DAF
ROM_PRINT   = $203C

start:
   exx
   push hl              ; preserve HL'

   ; demo instructions: nop, daa, halt, di, ei, in, out, retn, im, cpi, cpir
   ;                    ini, inir, outi, otir, cpd, cpdr, ind, indr, outd, otdr


   pop hl
   exx               ; restore HL' to gracefully return to BASIC
   ret



; Deployment: Snapshot
   SAVESNA "bit.sna", start
