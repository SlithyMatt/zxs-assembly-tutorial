   DEVICE ZXSPECTRUM48

   org $8000

IM2_TABLE   = $FE00
IM2_VECTOR  = $FDFD

start:
   ; Setup Interrupt Mode 2
   di                         ; disable interrupts
   ld de,IM2_TABLE            ; de = beginning of 257 bytes to set to $FD
   ld hl,IM2_VECTOR           ; hl = vector location ($FDFD)
   ld a,d                     ;
   ld i,a                     ; i = custom IM2 table page
   ld a,l                     ; a = $FD
@loop:
   ld (de),a                  ; set byte in IM2 table to $FD
   inc e                      ; de = next byte (unless e = 0)
   jp nz,@loop                ; loop until whole page is set to $FD (e = 0)
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
main_loop:
   
   jp main_loop               ; continue forever


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
