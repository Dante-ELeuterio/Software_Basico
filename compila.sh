as programa.s -o programa.o -g
gcc -g -c main.c -o main.o
ld programa.o main.o -o teste  -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 \/usr/lib/x86_64-linux-gnu/crt1.o  /usr/lib/x86_64-linux-gnu/crti.o \/usr/lib/x86_64-linux-gnu/crtn.o -lc
