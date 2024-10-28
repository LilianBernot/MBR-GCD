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
    je new_line
    ; inc bx to take following number
    mov [bx], al ; al is ASCII value
    inc bx

    jmp input_loop

new_line:
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10

print_prompt_input_number_1:
    mov ah, 0x0e 
    mov bx, prompt_number_1

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
    je end
    int 0x10
    inc bx
    jmp variable_loop

end:
    mov al, ' !'
    int 0x10

prompt_1:
  db "Please enter a number : ", 0

prompt_number_1:
  db "You entered the following number : ", 0

number_1:
  times 10 db 0

times 510-($-$$) db 0
dw 0xAA55