   DEVICE ZXSPECTRUM48

   org $8000

   jp start

; Character Codes
ENTER   = $0D
UPPER_A = $41
UPPER_Z = $5A
LOWER_A = $61
LOWER_Z = $7A

message:
   db "Like And Subscribe!",ENTER

MSG_LEN = $ - message

start:
   ; Print original message
   ld hl,message
   ld b,MSG_LEN
orig_loop:
   ld a,(hl)
   rst $10
   inc hl
   djnz orig_loop

   ; Print as all lowercase
   ld hl,message
   ld a,(hl)
lower_loop:
   cp UPPER_A
   jr c,print_lower_char
   cp UPPER_Z+1
   call c,tolower
print_lower_char:
   rst $10
   inc hl
   ld a,(hl)
   cp ENTER
   jr nz,lower_loop
   rst $10

   ; Print as all uppercase
   ld hl,message
   ld b,MSG_LEN
upper_loop:
   ld a,(hl)
   call toupper
   rst $10
   inc hl
   djnz upper_loop

   ; All done
   ret

tolower:
   add $20
   ret

toupper:
   cp LOWER_A
   ret c
   cp LOWER_Z+1
   ret nc
   sub $20
   ret

; Deployment: Snapshot
   SAVESNA "cond.sna", start
