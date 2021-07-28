   DEVICE ZXSPECTRUM48

   org $8000

   jp start

ENTER = $0D

scratch:
   dw 0              ; 2 bytes of RAM for general temporary use

start:
   ld a,$10
   add a,$02         ; A = $10 + $02 = $12, clears all flags
   ld hl,$3456
   call print_afhl   ; Print contents of A,F,H,L registers
   ld d,$0E
   add a,d           ; A = $12 + $0E = $20, sets H
   call print_afhl
   ld hl,scratch     ; HL = scratch address ($8003)
   ld (hl),$60
   add a,(hl)        ; A = $20 + $60 = $80, sets S and P/V
   call print_afhl
   add a,h           ; A = $80 + $80 = $00, sets Z , P/V and C
   call print_afhl
   inc a             ; A = $00 + $01 = $01, clears all flags, but leaves C set
   call print_afhl
   neg               ; A = $00 - $01 = $FF, sets S, H, N, and C
   call print_afhl
   ld bc,$0003
   sbc hl,bc         ; HL = $8003 - $0003 - 1 = $7FFF, sets H, P/V, and N
   call print_afhl
   sbc hl,hl         ; HL = $7FFF - $7FFF - 0 = $0000, set Z and N
   call print_afhl
   ret

print_afhl:
   push hl
   push af
   call print_hex    ; print A in hex
   ld (scratch),sp   ; copy SP to RAM
   ld bc,(scratch)   ; BC = stack pointer addresss
   ld a,(bc)         ; A = F at top of the stack
   call print_hex    ; print F in hex
   ld a,h            ; A = H
   call print_hex    ; print H in hex
   ld a,l            ; A = L
   call print_hex    ; print L in hex
   ld a,ENTER
   rst $10           ; new line
   pop af
   pop hl
   ret

print_hex:
   push hl
   push af
   srl a
   srl a
   srl a
   srl a                ; A = A >> 4
   call print_hex_digit ; print high nybble
   pop af               ; restore A
   and $0F              ; clear high nybble
   call print_hex_digit ; print low nybble
   pop hl
   ret

print_hex_digit:
   cp $0A
   jp p,print_letter    ; if S clear, A >= $0A
   or $30               ; A < $0A, just put $3 in upper nybble for number code
   jp print_char
print_letter:
   add $37              ; A >= $0A, add $37 to get letter code
print_char:
   rst $10              ; print code for digit
   ret


; Deployment: Snapshot
   SAVESNA "math.sna", start
