section .text
    org 0x7C00            ; Set the origin to 0x7C00, where the boot sector is loaded

start:
    ; Store the value 7 in AX register
    mov ax, 7

    ; Convert the integer in AX to ASCII
    add ax, '0'           ; Convert the integer (0-9) to its ASCII equivalent by adding '0' (48 in decimal)

    ; Print the converted ASCII character using BIOS interrupt 0x10
    mov ah, 0x0E          ; BIOS teletype function (int 0x10, ah=0x0E)
    mov al, al            ; Move the ASCII character in AL
    int 0x10              ; Interrupt call to BIOS to print the character in AL

    ; Print a newline (carriage return and line feed) after printing the number
    mov al, 0x0D          ; Carriage return
    int 0x10
    mov al, 0x0A          ; Line feed
    int 0x10

done:
    ; Infinite loop to prevent the program from exiting
    cli                   ; Disable interrupts
    hlt                   ; Halt the CPU

times 510-($-$$) db 0     ; Pad the binary to 510 bytes
dw 0xAA55                 ; Boot signature
