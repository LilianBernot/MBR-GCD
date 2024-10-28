        mov ax, 2345 
        mov bx, 35 
gcd:
        cmp ax, bx
        je end
        jl else
        sub ax, bx 
        jmp gcd
else:
        sub bx, ax 
        jmp gcd 

end: 
    mov dx, 0               ; Clear DX (we won't use it here for simplicity)
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


padding:
times 510-($-$$) db 0
dw 0xaa55