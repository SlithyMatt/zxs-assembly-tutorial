   DEVICE ZXSPECTRUM48

   org $8000

start:
   exx
   push hl           ; preserve HL'

   nop               ; Do absolutely nothing but waste time!

   ld bc,$3657       ; Load 3657 as BCD into BC
   ld de,$2845       ; Load 2845 as BCD into DE
   ld a,c
   add e             ; Add ones and tens places
   daa               ; Do BCD adjustment
   ld c,a
   ld a,b
   adc d             ; Add hundreds and thousands places (with possible carry)
   daa               ; Do BCD adjustment
   ld b,a            ; BC = BC + DE (BCD)
   call printhex     ; print decimal digits in B (thousands, hundreds)
   ld a,c
   call printhex     ; print decimal digits in C (tens, ones)
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

printhex: ; print A as hex
   push af           ; save full byte on stack
   srl a
   srl a
   srl a
   srl a             ; move upper nybble to lower spot
   or $30            ; convert to numeral character code
   rst $10           ; print upper nybble
   pop af            ; restore byte
   and $0F           ; clear out upper nybble
   or $30            ; convert lower nybble to character
   rst $10           ; print lower nybble
   ret


; Deployment: Snapshot
   SAVESNA "bit.sna", start
