   DEVICE ZXSPECTRUM48

   org $8000

   jp start

   ; ROM routines
ROM_CLS     = $0DAF
ROM_PRINT   = $203C

header:
   db "[   A  ][   B  ][   C  ][ (HL) ]"

hlvar:
   db 0

start:
   exx
   push hl              ; preserve HL'

   ; demo instructions: rlca, rrca, rla, rra, cpl, and, xor, or, rrd, rld,
   ;                    rlc, rrc, rl, rr, sla, sra, sll, srl, bit, res, set
   call ROM_CLS
   ld de,header
   ld bc,32
   call ROM_PRINT

   ld a,%01101010
   ld b,%10010101
   ld c,%11001100
   ld hl,hlvar
   ld (hl),%00111100

   call binregs
   rrca
   rrca
   call binregs
   scf
   sll a
   sla a
   call binregs
   sra a
   rr b
   rr c
   rr (hl)
   call binregs
   or b
   call binregs
   and c
   call binregs
   xor (hl)
   call binregs


   ; set colors
   ld b,22
   ld hl,$5800
.rowloop:
   ld d,0
   call setcolor
   inc d
   call setcolor
   inc d
   call setcolor
   inc d
   call setcolor
   dec b
   jp nz,.rowloop

   pop hl
   exx                  ; restore HL' to gracefully return to BASIC
   ret

binregs:
   push af
   call bina
   ld a,b
   call bina
   ld a,c
   call bina
   ld a,(hl)
   call bina
   pop af
   ret

bina:
   push bc
   ld b,8
.bitloop:
   rlca
   ld c,a
   jr c,.print1
   ld a,$30
   jp .next
.print1:
   ld a,$31
.next:
   rst $10
   ld a,c
   dec b
   jp nz,.bitloop
   pop bc
   ret

setcolor:
   ld c,8
.attrloop:
   ld a,(hl)
   or d
   ld (hl),a
   inc hl
   dec c
   jp nz,.attrloop
   ret

; Deployment: Snapshot
   SAVESNA "bit.sna", start
