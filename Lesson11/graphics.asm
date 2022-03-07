   DEVICE ZXSPECTRUM48

   org $8000

; Routines
CL_ALL      = $0DAF

; Control Codes
ENTER       = $0D
INK         = $10

start:
   im 1                 ; Use ROM-based interrupt routine
   ei                   ; Enable maskable interrupts
   call CL_ALL          ; Clear screen, reset cursor to top

; Deployment: Snapshot
   SAVESNA "graphics.sna", start
