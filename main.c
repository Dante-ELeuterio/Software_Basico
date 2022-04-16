#include <stdio.h>

extern long int* alocaMem();
extern void iniciaAlocador();
extern void liberaMem();
int main(int argc, char const *argv[])
{
    iniciaAlocador();
    long int *x=alocaMem(1000);
    long int *y=alocaMem(500);
    liberaMem(x);
    long int *z=alocaMem(500);
    long int *k=alocaMem(484);
    long int *j=alocaMem(1000);
    /*printf("X:\n");
    printf("%ld\n",x);
    printf("%ld\n",*(x-2));
    printf("%ld\n",*(x-1));
    printf("---------------------\n");*/
    
    printf("Z:\n");
    printf("%ld\n",z);
    printf("%ld\n",*(z-2));
    printf("%ld\n",*(z-1));
    printf("--------------------\n");

    printf("K:\n");
    printf("%ld\n",k);
    printf("%ld\n",*(k-2));
    printf("%ld\n",*(k-1));
    printf("---------------------\n");

    printf("Y:\n");
    printf("%ld\n",y);
    printf("%ld\n",*(y-2));
    printf("%ld\n",*(y-1));
    printf("---------------------\n");


    printf("J:\n");
    printf("%ld\n",j);
    printf("%ld\n",*(j-2));
    printf("%ld\n",*(j-1));
    printf("---------------------\n");



    return 0;
}
