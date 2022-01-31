   DEVICE ZXSPECTRUM48

   org $8000

start:
   exx
   push hl           ; preserve HL'

   nop               ; Do absolutely nothing but waste time!

   ld hl,$3657       ; Load 3657 as BCD into HL
   ld bc,$2845       ; Load 2845 as BCD into bc
   ld a,l
   add a,c           ; Add ones and tens places
   daa               ; Do BCD adjustment
   ld l,a
   ld a,h
   adc a,b           ; Add hundreds and thousands places (with possible carry)
   daa               ; Do BCD adjustment
   ld h,a            ; HL = HL + BC (BCD)
   call printhex     ; print decimal digits in H (thousands, hundreds)
   ld a,l
   call printhex     ; print decimal digits in L (tens, ones)
   ld a,$0D
   rst $10           ; print newline

   ; find the first NOP in main routine
   ld hl,start
   ld bc,printhex-start ; stop searching after end of routine code
   ld a,0            ; A = NOP opcode
   cpir
   dec hl
   ld a,h
   call printhex     ; print upper byte of first NOP address
   ld a,l
   call printhex     ; print lower byte
   ld a,$0D
   rst $10           ; print newline

   ; find the last NOP in main routine
   ld hl,printhex-1  ; start with last byte
   ld bc,printhex-start ; stop searching at beginning of routine code
   ld a,0            ; A = NOP opcode
   cpdr
   inc hl
   ld a,h
   call printhex     ; print upper byte of last NOP address
   ld a,l
   call printhex     ; print lower byte
   ld a,$0D
   rst $10           ; print newline

   nop               ; one more to do even more nothing

   pop hl
   exx               ; restore HL' to gracefully return to BASIC
   ret

printhex: ; print A as hex byte
   push af              ; save full byte on stack
   srl a
   srl a
   srl a
   srl a                ; move upper nybble to lower spot
   call printhex_digit  ; print upper nybble
   pop af               ; restore byte
   and $0F              ; clear out upper nybble
   call printhex_digit  ; print lower nybble
   ret

printhex_digit: ; print A as hex digit
   cp $0A
   jp p,print_letter
   or $30
   jp print_character
print_letter:
   add a,$37
print_character:
   rst $10
   ret

; Deployment: Snapshot
   SAVESNA "rest.sna", start
