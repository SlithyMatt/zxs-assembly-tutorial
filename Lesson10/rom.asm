   DEVICE ZXSPECTRUM48

   org $8000

; Routines
PRINTOUT    = $09F4
KEYIN       = $10A8

; ROM Data
KEYTABLE_D  = $0260

; Control Codes
ENTER       = $0D
INK         = $10

start:
   im 1
   ei
key_loop:
   call KEYIN
   jp nc,key_loop
   cp $20
   jp m,check_control
   cp $80
   jp m,print
check_control:
   cp ENTER
   jp z,print
   ld hl,KEYTABLE_D
   ld b,0
   ld c,8
ink_loop:
   cp (hl)
   jp z,do_ink
   inc hl
   inc b
   dec c
   jp nz,ink_loop
   jp key_loop
do_ink:
   ld a,INK
   push bc
   call PRINTOUT
   pop bc
   ld a,b
   add a,$30
print:
   call PRINTOUT
   jp key_loop

; Deployment: Snapshot
   SAVESNA "rom.sna", start
