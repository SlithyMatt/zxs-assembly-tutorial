   DEVICE ZXSPECTRUM48

   org $8000

IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD

SCREEN_LINE = $4860  ; Line 88

position:
   db 124,0

sprite:
   db %00111100
   db %01110110
   db %11111011
   db %11111101
   db %11111111
   db %11111111
   db %01111110
   db %00111100

line_buffer:
   .256 db 0

start:
   ; Setup Interrupt Mode 2
   di                         ; disable interrupts
   ld de,IM2_TABLE            ; de = beginning of 257 bytes to set to $FD
   ld hl,IM2_VECTOR           ; hl = vector location ($FDFD)
   ld a,d                     ;
   ld i,a                     ; i = custom IM2 table page
   ld a,l                     ; a = $FD
.fill_loop:
   ld (de),a                  ; set byte in IM2 table to $FD
   inc e                      ; de = next byte (unless e = 0)
   jp nz,.fill_loop           ; loop until whole page is set to $FD (e = 0)
   inc d                      ; de = 257th byte of table
   ld (de),a                  ; set last byte to $FD
   ld (hl),$C3                ; place unconditional JP opcode at vector
   inc l                      ; hl = vector + 1
   ld (hl),low im2_handler    ; low byte of custom handler address
   inc l                      ; hl = vector + 2
   ld (hl),high im2_handler   ; high byte of custom handler address
   im 2                       ; set interrupt mode 2
   ei                         ; re-enable interrupts

   ; Main thread of execution:
   jp draw_sprite             ; draw sprite at initial position, then loop back
main_loop:
   halt                       ; wait for interrupt
   ld bc,$FEFE                ; BC = Port $FEFE (in: keyboard[Shift,Z,X,C,V]
   in a,(c)                   ; scan keyboard
   and $06                    ; check for Z or X
   jp z,main_loop             ; if both pressed, return to top of loop
   cp $06
   jp z,main_loop             ; if neither pressed, return to top of loop
   ld hl,position             ; HL = address of position
   bit 1,a                    ; check state of Z key (Bit 1)
   jp z,.go_left              ; if Z pressed, go left
   ld a,(HL)                  ; X must be pressed, get current position
   cp 248                     ; check to see if already at the far right end
   jp z,main_loop             ; if already there, don't move, return to top
   inc a                      ; move one pixel to right
   jp .store_pos              ; jump ahead to store new position
.go_left:
   ld a,(HL)                  ; Z must be pressed, get current position
   cp 0
   jp z,main_loop             ; if already zero, don't move, return to top
   dec a                      ; move one pixel to left
.store_pos:
   ld (hl),a                  ; store new position value

   ; now, update line buffer with new sprite position
draw_sprite:
   ld hl,line_buffer          ; HL = beginning line buffer
   ld bc,(position)           ; BC = starting sprite pixel position
   srl c
   srl c
   srl c                      ; BC = position/8
   add hl,bc                  ; HL = starting address of sprite destination
   push hl
   pop ix                     ; IX = HL
   ld a,(position)            ; A = position
   cp 0
   jp z,.draw                 ; If A=0, jump to drawing sprite
   and $07                    ; A = A%8
   jp nz,.draw                ; If A > 0, no need clear previous, jump ahead
   dec hl                     ; go back to previous address
   ld b,8                     ; loop through 8 lines
   ld de,32                   ; 32 bytes per line
.prev_loop:
   ld (hl),0                  ; clear pixels to left
   add hl,de                  ; next line
   dec b                      ; decrement loop index
   jp nz,.prev_loop           ; keep looping until zero
.draw:
   and $07                    ; A = A%8
   ld b,a                     ; B = A; store shift loop init
   ld c,8                     ; C = line loop index (sprite height)
   ld hl,sprite               ; HL = sprite pixels
.line_loop:
   ld d,(hl)                  ; DE = sprite line
   ld e,0
   ld a,b                     ; init shift loop
   cp 0
   jp z,.draw_line            ; if A already zero, no need to shift
.shift_loop:
   srl d
   rr e                       ; shift sprite line to right
   dec a                      ; decrement loop index
   jp nz,.shift_loop          ; keep looping until zero
.draw_line:
   ld (ix),d                  ; draw left byte
   ld (ix+1),e                ; draw right byte
   ld de,32                   ; 32 bytes per line
   add ix,de                  ; go to next line in buffer
   inc hl                     ; and get next line of sprite
   dec c                      ; decrement line loop index
   jp nz,.line_loop           ; keep looping until zero
   jp main_loop               ; forever wait for next interrupt

im2_handler:
   di                         ; disable other interrupts
   ; stash all registers to stack
   push af
   push bc
   push de
   push hl
   ex af,af'                  ; exchange AF and AF'
   exx                        ; exchange BE,DE,HL with BE',DE',HL'
   push af
   push bc
   push de
   push hl
   push ix
   push iy

   ; Interrupt routine:
   ld hl,line_buffer          ; HL = start of line buffer
   ld de,SCREEN_LINE          ; DE = start of destination screen memory
   ld b,8                     ; line index
.line_loop:
   ld c,32                    ; pixel byte loop index
.byte_loop:
   ld a,(hl)
   ld (de),a                  ; copy byte from line buffer to screen memory
   inc hl
   inc e
   dec c                      ; decrement loop index for next byte
   jp nz,.byte_loop           ; keep looping for all bytes in line
   ld e,low SCREEN_LINE
   inc d                      ; DE = next line in screen memory
   dec b                      ; decrement loop index for next line
   jp nz,.line_loop           ; loop until all lines are copied

   ; restore all registers from stack
   pop iy
   pop ix
   pop hl
   pop de
   pop bc
   pop af
   ex af,af'                  ; exchange AF and AF'
   exx                        ; exchange BE,DE,HL with BE',DE',HL'
   pop hl
   pop de
   pop bc
   pop af
   ei                         ; re-enable interrupts
   ret

; Deployment: Snapshot
   SAVESNA "irq.sna", start
