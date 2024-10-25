section .text
    org 0x7C00

; ------------ Print every letter we press :
; input:
;     mov ah, 0
;     int 0x16
;     mov ah, 0x0e
;     int 0x10
;     jmp input

mov ah, 0x0e ; Enter writing mode 
mov bx, prompt ; bx is always the memory holder. In the beginning, it holds the memory of the prompt

; Print the prompt
print_prompt:
  mov al, [bx]
  cmp al, 0
  je get_input
  int 0x10
  inc bx
  jmp print_prompt

; Get the input and store it into the variable
get_input:
    mov bx, variable
    input_loop:
    mov ah, 0
    int 0x16
    cmp al, 0x0D ; The input ends when 0D is given. 
    je new_line
    mov [bx], al
    inc bx
    jmp input_loop

; Print a new line
new_line:
  mov ah, 0x0e ; Enter writing mode
  mov al, 13
  int 0x10
  mov al, 10
  int 0x10

; Print the hello message
print_hello:
  mov bx, hello
  prompt_loop:
  mov al, [bx]
  cmp al, 0
  je print_variable
  int 0x10
  inc bx
  jmp prompt_loop

; Print the user input!
print_variable:
  mov bx, variable
  variable_loop:
  mov al, [bx]
  cmp al, 0
  je end
  int 0x10
  inc bx
  jmp variable_loop

; Add a '!' in the end (optional)
end:
  mov al, '!'
  int 0x10

; jmp $ ; Is this nesecary?

; Data
prompt:
  db "What's your name? ", 0

hello:
  db "Hello ", 0

variable:
  times 10 db 0

times 510-($-$$) db 0
dw 0xAA55