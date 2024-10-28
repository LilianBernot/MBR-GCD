## This is a school project.
The goal is to write an assembly program that would take two numbers as inputs and print their greatest common divider.

To assemly the code and start the qemu terminal, run : 
```
nasm -o gcd.bin -f bin gcd.S
qemu-system-i386 -fda gcd.bin
```

## Content
In this repo you will find : 
- a Makefile, to run the code
- a tests folder with some intermediate files to test stuff that helped me understand fhow assembly works
- a gcd.S file : the actual runnable code that computes the GCD of input numbers

## Potential improvements

Code is not really reusable. As we can see, code is repeated for the following : 
- get number input
- transform from ASCII to decimal
- display a new line
- display prompts
