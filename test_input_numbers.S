section .text
    org 0x7C00

; ----------- For now, code asks for a number and prints its value.

mov ah, 0x0e ; Enter writing mode 
mov bx, prompt_1 ; bx is always the memory holder. In the beginning, it holds the memory of the prompt_1

print_prompt_1:
  mov al, [bx]
  cmp al, 0
  je get_input_1
  int 0x10
  inc bx
  jmp print_prompt_1

get_input_1:
    mov bx, number_1

input_loop:
    ; get input
    mov ah, 0
    int 0x16    
    ; check if is Enter
    cmp al, 0x0D
    je new_line_1
    ; inc bx to take following number
    mov [bx], al ; al is ASCII value
    inc bx

    jmp input_loop

new_line_1:
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10

start_print_prompt_2:
    mov ah, 0x0e ; Enter writing mode 
    mov bx, prompt_2 ; bx is always the memory holder. In the beginning, it holds the memory of the prompt_1

print_prompt_2:
  mov al, [bx]
  cmp al, 0
  je get_input_2
  int 0x10
  inc bx
  jmp print_prompt_2

get_input_2:
    mov bx, number_2

input_loop_2:
    ; get input
    mov ah, 0
    int 0x16    
    ; check if is Enter
    cmp al, 0x0D
    je new_line
    ; inc bx to take following number
    mov [bx], al ; al is ASCII value
    inc bx

    jmp input_loop_2

new_line:
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10

print_prompt_input_number_1:
    mov ah, 0x0e 
    mov bx, prompt_number

print_prompt_input_number_1_loop:
  mov al, [bx]
  cmp al, 0
  je print_number_1
  int 0x10
  inc bx
  jmp print_prompt_input_number_1_loop

print_number_1:
  mov bx, number_1
  variable_loop:
    mov al, [bx]
    cmp al, 0
    je comma
    int 0x10
    inc bx
    jmp variable_loop

comma:
    mov al, ','
    int 0x10

print_prompt_input_number_2_loop:
  mov al, [bx]
  cmp al, 0
  je print_number_2
  int 0x10
  inc bx
  jmp print_prompt_input_number_2_loop

print_number_2:
  mov bx, number_2
  variable_loop_2:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp variable_loop_2

end:
    mov al, '!'
    int 0x10

prompt_1:
  db "Please enter a number : ", 0

prompt_2:
  db "Please enter a second number : ", 0

prompt_number:
  db "You entered the following numbers : ", 0

number_1:
  times 10 db 0

number_2:
  times 10 db 0

times 510-($-$$) db 0
dw 0xAA55