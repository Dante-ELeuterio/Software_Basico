as programa.s -o programa.o -g
gcc -g -c main.c -o main.o
gcc -static main.o programa.o -o teste
