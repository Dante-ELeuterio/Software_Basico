as meuAlocador_worst.s -o meuAlocador_worst.o -g
gcc -g -c main.c -o main.o
ld meuAlocador_worst.o main.o -o meuAlocador_worst  -dynamic-linker /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 \/usr/lib/x86_64-linux-gnu/crt1.o  /usr/lib/x86_64-linux-gnu/crti.o \/usr/lib/x86_64-linux-gnu/crtn.o -lc
