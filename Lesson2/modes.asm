   DEVICE ZXSPECTRUM48

   org $8000

   jp start             ; jump over data to code (extended immediate)

string:
   db "hello"

STRING_LENGTH = 5
ENTER = $0D

start:
   im 1                 ; Set interrupt mode to 1
   ld hl,string         ; HL = address of string (register,extended immediate)
   ld b,STRING_LENGTH   ; B = length of string (register,immediate)
loop:
   ld a,(hl)            ; A = byte at address in HL (register,register indirect)
   rst $10              ; print character code in A (modified page zero)
   inc hl               ; increment HL to address of next character (register)
   dec b                ; decrement B (register)
   jr nz,loop           ; if B not zero, jump back to top of loop (condition,relative)
   ld a,ENTER           ; A = Enter character code (register,immediate)
   rst $10              ; print Enter for new line (modified page zero)

   ; Let's do it again, but unrolled and with the first letter capitalized
   ld ix,string         ; IX = address of string (register,extended immediate)
   res 5,(ix)           ; reset bit 5 of first character (bit,indexed)
   ld a,(ix)            ; A = string[0] (register,indexed)
   rst $10              ; print character (modified page zero)
   ld a,(ix+1)          ; A = string[1] (register,indexed)
   rst $10              ; print character (modified page zero)
   ld a,(ix+2)          ; A = string[2] (register,indexed)
   rst $10              ; print character (modified page zero)
   ld a,(ix+3)          ; A = string[3] (register,indexed)
   rst $10              ; print character (modified page zero)
   ld a,(ix+4)          ; A = string[4] (register,indexed)
   rst $10              ; print character (modified page zero)
   ld a,ENTER           ; A = Enter character code (register,immediate)
   rst $10              ; print Enter for new line (modified page zero)

   ; And, we're done
   ret                  ; return from call (implied)


; Deployment: Snapshot
   SAVESNA "modes.sna", start
