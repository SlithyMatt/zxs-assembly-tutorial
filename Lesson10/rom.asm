   DEVICE ZXSPECTRUM48

   org $8000

; Routines
CL_ALL      = $0DAF
KEY_INPUT   = $10A8

; Character Codes
SPACE       = $20
COPYRIGHT   = $7F

; Control Codes
ENTER       = $0D
INK         = $10
AT          = $AC

start:
   im 1                 ; Use ROM-based interrupt routine
   ei                   ; Enable maskable interrupts
   call CL_ALL          ; Clear screen, reset cursor to top
key_loop:
   call KEY_INPUT       ; Get last key pressed
   jp nc,key_loop       ; If C is clear, keep waiting for key press
   cp AT                ; Key has been pressed
   jp z,do_ink          ; If AT code (Symbol Shift + I), wait for ink color
   cp ENTER
   jp z,print           ; If ENTER code, print
   cp SPACE
   jp m,key_loop        ; If code < space character, ignore
   cp COPYRIGHT+1
   jp m,print           ; If code <= copyright character, print
   jp key_loop          ; Else, ignore
do_ink:
   ld a,INK
   rst $10              ; "print" INK code
ink_loop:
   call KEY_INPUT
   jp nc,ink_loop       ; wait for another key press
   cp $30
   jp m,reset_ink       ; if code < '0', reset ink color
   cp $38
   jp p,reset_ink       ; if code >= '8', reset ink color
   sub $30              ; get numerical value of numeral character...
   jp print             ; ...and "print" it as ink value
reset_ink:
   ld a,0               ; reset ink to black by "printing" zero
print:
   rst $10              ; print final code
   jp key_loop          ; keep looping indefinitely

; Deployment: Snapshot
   SAVESNA "rom.sna", start
