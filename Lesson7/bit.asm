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
   rrca              ; A: 01101010 --> 00110101, carry clear
   rrca              ; A: 00110101 --> 10011010, carry set
   call binregs
   scf               ; set carry flag
   ccf               ; complement carry flag --> clear
   sll a             ; A: 10011010 --> 00110101, carry set
   sla a             ; A: 00110101 --> 01101010, carry clear
   call binregs
   sra a             ; A: 01101010 --> 00110101, carry clear
   rr b              ; B: 10010101 --> 01001010, carry set
   rr c              ; C: 11001100 --> 11100110, carry clear
   rr (hl)           ; (HL): 00111100 --> 00011110, carry clear
   call binregs
   or b              ; A: 00110101 --> 00110101 | 01001010 = 01111111
   call binregs
   and c             ; A: 01111111 --> 01111111 & 11100110 = 01100110
   call binregs
   xor (hl)          ; A: 01100110 --> 01100110 ^ 00011110 = 01111000
   call binregs
   rld               ; A: 01111000, (HL): 00011110 --> A: 01110001, (HL): 11101000
   call binregs
   rrd               ; A: 01110001, (HL): 11101000 --> A: 01111000, (HL): 00011110
   call binregs
   set 0,a           ; A: 01111000 --> 01111001
   res 1,b           ; B: 01001010 --> 01001000
   call binregs
   scf               ; set carry flag
.bitloop:            ; C: 11100110 --> 10011010
   rl c
   call binregs
   bit 4,c
   jp z,.bitloop

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
