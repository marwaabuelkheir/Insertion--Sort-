include 'emu8086.inc'
org     100h

.data   
msg1  db 0Dh,0Ah, 'Enter the length of the vector (db): $'

msg2  db 0Dh,0Ah, 'Enter an element (0-127): $'  

;msg3  db 0Dh,0Ah, 'The sorted vector in ascending order is: $'  

n_line DB 0AH,0DH,"$"   

lun  dw ?

vec db 127 DUP(?)

.code

; Display the message to enter the number of elements
mov dx, offset msg1
mov ah, 9
int 21h
call    scan_num 

; Store the entered number in the variable lun (length)
mov     lun, cx

; Read the n elements from the keyboard
mov bx, lun 
mov si, 0
citire:
; Display the message to enter an element 
mov dx, offset msg2
mov ah, 9
int 21h
call    scan_num  
; Store the entered element in the vector
mov vec[si], cl
inc si
dec bx
cmp bx,0
jne citire
je next 

; In case there is only one element
nu: 
mov cx, lun 
mov si, 0 
; Display a new line
lea dx, n_line
mov ah, 9
int 21h
jmp afisare

; Sorting algorithm
next: mov SI, 1
cmp lun,1
je nu 
jmp for1
for1: mov ah,vec[SI]  
      mov di, si
      dec di 
      mov bh, vec[di] 
      jmp while
while: cmp di,0 
       jl for2
       mov bh, vec[di]
       cmp ah,bh
       jge for2 
       mov vec[di+1], bh
       dec di
       jmp while
for2: mov vec[di+1], ah
      inc si
      cmp si, lun
      jl for1
      ; Prepare variables for display
      mov cx, lun 
      mov si, 0 
      ; Display a new line
      lea dx, n_line
      mov ah, 9
      int 21h
      jge afisare

afisare: 
; Display the number, print_num displays what is in reg ax
mov ah, 0
mov al, vec[si]
call print_num 
; Display space
mov dl, ' '
mov ah,2
int 21h
inc si
loop afisare

jmp     exit
; Process overflow error:
overflow:

   printn 'we have overflow!'

exit:
; Wait for any key press:
mov ah, 0
int 16h
ret   ; Return control to operating system.

DEFINE_SCAN_NUM   
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

end