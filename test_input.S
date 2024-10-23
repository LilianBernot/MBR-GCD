section .text
    org 0x7C00               ; Set the origin to 0x7C00, where the boot sector is loaded

start:
    ; Initialize registers
    xor ax, ax               ; Clear AX to store the final input number
    xor bx, bx               ; Clear BX to use as a temporary register

read_input:
    ; Wait for user input (get character from keyboard)
    mov ah, 0x00             ; BIOS service to read a keystroke (int 0x16, ah=0x00)
    int 0x16                 ; Get the keystroke in AL

    ; Check if the key is 'Enter' (ASCII 0x0D means the user pressed Enter)
    ; cmp al, 0x0D
    ; je print_number          ; If 'Enter', we stop reading and go to print the number

    ; Convert the character in AL to its digit value
    ; sub al, '0'              ; Convert ASCII character to number (e.g., '5' -> 5)
    
    ; Update the number in AX by multiplying by 10 and adding the new digit
    ; mov bx, ax               ; Move current number to BX
    ; mov ax, 10               ; Prepare to multiply current number by 10
    ; mul bx                   ; AX = AX * BX (current number * 10)
    ; add ax, al               ; Add the new digit to the current value in AX

    ; add ax, 7

    ; jmp read_input           ; Continue reading the next character

print_number:
    ; Print the final number (AX contains the number)
    mov cx, 0                ; Initialize digit count (CX will hold the number of digits)
    mov dx, 0
    ; mov ax, 9876

next_digit:
    xor dx, dx               ; Clear DX before division (DX:AX / BX)
    mov bx, 10               ; Divisor for decimal system
    div bx                   ; DX:AX / 10 -> quotient in AX, remainder in DX (next digit)

    push dx                  ; Push the remainder (next digit) onto the stack
    inc cx                   ; Increment digit counter
    cmp ax, 0                ; Check if the quotient is zero (all digits extracted)
    jne next_digit           ; If not, continue extracting digits

print_digits:
    pop dx                   ; Pop the last digit (most significant) from the stack
    add dl, '0'              ; Convert the digit to its ASCII equivalent
    
    ; Print the character using BIOS interrupt 0x10
    mov ah, 0x0E             ; BIOS teletype function
    mov al, dl               ; Move the ASCII character to AL
    int 0x10                 ; Print the character in AL

    loop print_digits        ; Repeat until all digits are printed

    ; Print a newline (carriage return and line feed) after printing the number
    mov al, 0x0D             ; Carriage return
    int 0x10
    mov al, 0x0A             ; Line feed
    int 0x10

done:
    ; Infinite loop to prevent the program from exiting
    cli                      ; Disable interrupts
    hlt                      ; Halt the CPU

times 510-($-$$) db 0        ; Pad the binary to 510 bytes
dw 0xAA55                    ; Boot signature