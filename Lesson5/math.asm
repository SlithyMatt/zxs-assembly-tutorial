   DEVICE ZXSPECTRUM48

   org $8000

   jp start

sp_cache:
   dw 0

start:
   ld a,$12
   ld bc,$3456
   call print_afbc
   ret

print_afbc:
   push af
   call print_hex
   ld (sp_cache),sp
   ld hl,(sp_cache)
   ld a,(hl)
   call print_hex
   ld a,b
   call print_hex
   ld a,c
   call print_hex
   pop af
   ret

print_hex:
   push af
   srl a
   srl a
   srl a
   srl a
   call print_hex_digit
   pop af
   and $0F
   call print_hex_digit
   ret

print_hex_digit:
   cp $0A
   jp p,print_letter
   or $30
   jp print_char
print_letter:
   add $37
print_char:
   rst $10
   ret


; Deployment: Snapshot
   SAVESNA "math.sna", start
