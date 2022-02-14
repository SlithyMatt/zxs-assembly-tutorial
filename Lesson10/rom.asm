   DEVICE ZXSPECTRUM48

   org $8000

; Routines
PRINTOUT = $09A1
KEYIN    = $10A8

; Control Codes
INK      = $10


start:
   call KEYIN
   jp nc,start
   call PRINTOUT

; Deployment: Snapshot
   SAVESNA "rest.sna", start
