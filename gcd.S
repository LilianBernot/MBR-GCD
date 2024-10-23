section .text
    org 0x7C00              ; Set the origin to 0x7C00, where the boot sector is loaded

start:
    ; Store the value 98765 in DX:AX (since 16-bit registers are limited to 65535 in AX)
    mov si, message

print_char:
    lodsb                ; Load next byte from [SI] into AL
    cmp al, 0            ; Check if we reached the end of the string (null terminator)
    je newline_after_init              ; If yes, jump to 'done'
    
    mov ah, 0x0E         ; BIOS teletype function (int 0x10, ah=0x0E)
    int 0x10             ; Interrupt call to BIOS to print the character in AL
    jmp print_char       ; Repeat for the next character

newline_after_init:
    mov al, 0x0D          ; Carriage return
    int 0x10
    mov al, 0x0A          ; Line feed
    int 0x10
    jmp print_number

print_number: 
    mov dx, 0               ; Clear DX (we won't use it here for simplicity)
    mov ax, 9876           ; Move the number 98765 into AX

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

    ; Print a newline (carriage return and line feed) after printing the number
    mov al, 0x0D            ; Carriage return
    int 0x10
    mov al, 0x0A            ; Line feed
    int 0x10

done:
    ; Infinite loop to prevent the program from exiting
    cli                     ; Disable interrupts
    hlt                     ; Halt the CPU

message db 'Please enter a number!', 0  ; The message to print, ending with a null byte

times 510-($-$$) db 0       ; Pad the binary to 510 bytes
dw 0xAA55                   ; Boot signature
