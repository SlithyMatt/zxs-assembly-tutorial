   DEVICE ZXSPECTRUM48

   org $8000

; Routines
PRINTOUT    = $09F4
KEYIN       = $10A8

; Character Codes
SPACE       = $20
POUND       = $60
COPYRIGHT   = $7F

; Control Codes
ENTER       = $0D
INK         = $10

start:
   im 1
   ei
key_loop:
   call KEYIN
   jp nc,key_loop
   cp POUND
   jp z,do_ink
   cp SPACE
   jp m,check_enter
   cp COPYRIGHT+1
   jp m,print
check_control:
   cp ENTER
   jp z,print
   jp key_loop
do_ink:
   ld a,INK
   call PRINTOUT
ink_loop:
   call KEYIN
   jp nc,ink_loop
   cp $30
   jp m,key_loop
   cp $3A
   jp p,key_loop
print:
   call PRINTOUT
   jp key_loop

; Deployment: Snapshot
   SAVESNA "rom.sna", start
