This is a school project.
The goal is to write an assembly program that would take two numbers as inputs and print their greatest common divider.

To assemly the code and start the qemu terminal, run : 
```
nasm -o gcd.bin -f bin gcd.S
qemu-system-i386 -fda gcd.bin
```