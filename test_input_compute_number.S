section .text
    org 0x7C00

; print initial prompt to explain concept
print_initial_prompt:
    mov ah, 0x0e ; Enter writing mode 
    mov bx, initial_prompt ; bx is always the memory holder. In the beginning, it holds the memory of the prompt

print_initial_prompt_loop:
  mov al, [bx]
  cmp al, 0
  je new_line
  int 0x10
  inc bx
  jmp print_initial_prompt_loop

new_line:
  mov ah, 0x0e ; Enter writing mode
  mov al, 13
  int 0x10
  mov al, 10
  int 0x10

; print second prompt to ask for user to input first number
print_prompt_number_1:
    mov ah, 0x0e 
    mov bx, prompt_number_1

print_prompt_number_1_loop:
  mov al, [bx]
  cmp al, 0
  je get_input_1
  int 0x10
  inc bx
  jmp print_prompt_number_1_loop

get_input_1:
    mov bx, number

input_loop:
    ; get input
    mov ah, 0
    int 0x16   
    ; check if is Enter
    cmp al, 0x0D
    je new_line_1
    ; print the input character
    mov ah, 0x0e
    int 0x10
    ; inc bx to take following digit
    mov [bx], al ; al is ASCII value
    inc bx

    jmp input_loop

new_line_1:
  mov ah, 0x0e ; Enter writing mode
  mov al, 13
  int 0x10
  mov al, 10
  int 0x10

ascii_to_binary:
    xor ax, ax              ; Clear AX (will hold final binary result)
    mov bx, number          ; Point BX to beginning of number[]
    
ascii_loop:
    mov dl, [bx]            ; Get the digit
    cmp dl, 0               ; Check if end of input
    je store_first_input

    sub dl, '0'             ; Convert ASCII to numeric value (0-9)

    ; Multiply AX by 10 
    add ax, ax          ; ax = ax0*2    
    mov cx, ax          ; cx = 2*ax0
    add cx, cx          ; cx = 4*ax0
    add cx, cx          ; cx = 8*ax0
    add ax, cx          ; ax = ax + cx = 8*ax0 + 2*ax0 = 10*ax0
    add ax, dx          ; AX = AX * 10 + DL
    inc bx              ; Move to next digit
    jmp ascii_loop

store_first_input:
    ; We store the first input number on top of the stack to retrieve it later on
    push ax 

; prompt to ask for second user input
print_prompt_number_2:
    mov ah, 0x0e 
    mov bx, prompt_number_2

print_prompt_number_2_loop:
  mov al, [bx]
  cmp al, 0
  je get_input_2
  int 0x10
  inc bx
  jmp print_prompt_number_2_loop

; get second user input
get_input_2:
    mov bx, number

input_loop_2:
    ; get input
    mov ah, 0
    int 0x16   
    ; check if is Enter
    cmp al, 0x0D
    je new_line_2

    ; print the input character
    mov ah, 0x0e
    int 0x10

    ; inc bx to take following number
    mov [bx], al ; al is ASCII value
    inc bx

    jmp input_loop_2

new_line_2:
  mov ah, 0x0e ; Enter writing mode
  mov al, 13
  int 0x10
  mov al, 10
  int 0x10

ascii_to_binary_2:
    xor ax, ax              ; Clear AX (will hold final binary result)
    mov bx, number          ; Point BX to beginning of number[]
    
ascii_loop_2:
    mov dl, [bx]            ; Get the digit
    cmp dl, 0               ; Check if end of input
    je compute_gcd

    sub dl, '0'             ; Convert ASCII to numeric value (0-9)

    ; Multiply AX by 10 
    add ax, ax          ; ax = ax0*2    
    mov cx, ax          ; cx = 2*ax
    add cx, cx          ; cx = 4*ax0
    add cx, cx          ; cx = 8*ax0
    add ax, cx          ; ax = ax + cx = 8*ax0 + 2*ax0 = 10*ax0
    add ax, dx              ; AX = AX * 10 + DL
    inc bx                  ; Move to next digit
    jmp ascii_loop_2

; compute GCD
compute_gcd:
    ; We retrieve the first input number and store it in bx before doing the calculations
    pop bx

    jmp gcd

gcd:
    cmp ax, bx
    je print_prompt_result
    jl else
    sub ax, bx 
    jmp gcd
else:
    sub bx, ax 
    jmp gcd

; prompt to display the result of the computation
print_prompt_result:
    ; We store the result in the stack because we will print a message
    push ax 

    mov ah, 0x0e 
    mov bx, prompt_result

print_prompt_result_loop:
  mov al, [bx]
  cmp al, 0
  je print_result
  int 0x10
  inc bx
  jmp print_prompt_result_loop

; Print the result of the GCD computation
print_result: 
    ; We pop the result of the computation out of the stack 
    pop ax

    ; Set up a stack to store digits
    mov cx, 0               ; Initialize digit count (CX will hold the number of digits)

next_digit:
    xor dx, dx              ; Clear DX before division (DX:AX / BX)
    mov bx, 10              ; Divisor for decimal system
    div bx                  ; DX:AX / 10 -> quotient in AX, remainder in DX (remainder = next digit)
    
    push dx                 ; Push the remainder (next digit) onto the stack
    inc cx                  ; Increment digit counter
    cmp ax, 0               ; Check if the quotient is zero (all digits extracted)
    jne next_digit          ; If not, continue extracting digits

print_digits:
    ; Now CX holds the number of digits, and the digits are on the stack
    pop dx                  ; Pop the last digit (which is the most significant) from the stack
    add dl, '0'             ; Convert the digit to its ASCII equivalent
    
    ; Print the character using BIOS interrupt 0x10
    mov ah, 0x0E            ; BIOS teletype function
    mov al, dl              ; Move the ASCII character to AL
    int 0x10                ; Print the character in AL

    loop print_digits       ; Repeat until all digits are printed

initial_prompt:
    db "This code aims at computing the GCD of two numbers."

prompt_number_1:
  db "Please enter your first number : ", 0

prompt_number_2:
  db "Please enter your second number : ", 0

prompt_result:
  db "The GCD of these two numbers is : ", 0

number:
  times 10 db 0

times 510-($-$$) db 0
dw 0xAA55