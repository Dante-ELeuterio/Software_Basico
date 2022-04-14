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
    printf("X:\n");
    printf("%d\n",x);
    printf("%d\n",*(x+1));
    printf("%d\n",*(x+2));
    printf("---------------------\n");
    
    printf("Y:\n");
    printf("%d\n",y);
    printf("%d\n",*(y+1));
    printf("%d\n",*(y+2));
    printf("---------------------\n");

    
    printf("Z:\n");
    printf("%d\n",z);
    printf("%d\n",*(z+1));
    printf("%d\n",*(z+2));
    printf("--------------------\n");

    printf("K:\n");
    printf("%d\n",k);
    printf("%d\n",*(k+1));
    printf("%d\n",*(k+2));


    return 0;
}
