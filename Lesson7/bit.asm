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

   ; set initial register values
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
.bitloop:            ; C: 11100110 --> 11001101 --> 10011011
   rl c
   call binregs
   bit 4,c
   jp z,.bitloop

   ; set colors
   ld b,22           ; set color attributes for first 22 lines
   ld hl,$5800       ; starting at top
.rowloop:
   ld d,0
   call setcolor     ; First column (A) = black
   inc d
   call setcolor     ; B = blue
   inc d
   call setcolor     ; C = red
   inc d
   call setcolor     ; (HL) = magenta
   dec b
   jp nz,.rowloop    ; loop until B = 0

   pop hl
   exx               ; restore HL' to gracefully return to BASIC
   ret

binregs:             ; Prints A, B, C and (HL) in binary
   push af           ; preserve A on stack
   call bina         ; Print A
   ld a,b
   call bina         ; Print B
   ld a,c
   call bina         ; Print C
   ld a,(hl)
   call bina         ; Print (HL)
   pop af            ; Restore A
   ret

bina:                ; Prints A in binary
   push bc           ; Preserve BC on stack
   ld b,8            ; Loop for all 8 bits
.bitloop:
   rlca              ; Shift high bit of A into carry bit
   ld c,a            ; Preserve A in C
   jr c,.print1      ; Print "1" if carry bit set
   ld a,$30          ; Carry bit clear, A = "0"
   jp .next
.print1:
   ld a,$31          ; A = "1"
.next:
   rst $10           ; Print character code in A ("0" or "1")
   ld a,c            ; Restore A
   dec b
   jp nz,.bitloop    ; Continue looping until B = 0
   pop bc            ; Restore BC
   ret

setcolor:   ; Input: D = new ink color, HL = color attribute address
   ld c,8            ; Loop for 8 color attributes
.attrloop:
   ld a,(hl)         ; A = current color attribute (ink assumed to be black)
   or d              ; A = A | D (set new ink color)
   ld (hl),a         ; Write back new color attribute
   inc hl            ; HL = next color attribute
   dec c
   jp nz,.attrloop   ; loop until C = 0
   ret

; Deployment: Snapshot
   SAVESNA "bit.sna", start
