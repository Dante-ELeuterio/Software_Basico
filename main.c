#include <stdio.h>

extern long int* alocaMem();
extern void iniciaAlocador();
extern void liberaMem();
int main(int argc, char const *argv[])
{
    iniciaAlocador();
    long int *x=alocaMem(1000);
    printf("X:\n");
    printf("%d\n",x);
    printf("%d\n",*(x+1));
    printf("%d\n",*(x+2));
    printf("---------------------\n");
    
    long int *y=alocaMem(500);
    printf("Y:\n");
    printf("%d\n",y);
    printf("%d\n",*(y+1));
    printf("%d\n",*(y+2));
    printf("---------------------\n");

    liberaMem(x);
    printf("X:\n");
    printf("%d\n",x);
    printf("%d\n",*(x+1));
    printf("%d\n",*(x+2));
    printf("--------------------\n");
    
    long int *z=alocaMem(500);
    printf("Z:\n");
    printf("%d\n",z);
    printf("%d\n",*(z+1));
    printf("%d\n",*(z+2));
    printf("--------------------\n");

    long int *k=alocaMem(200);
    printf("K:\n");
    printf("%d\n",k);
    printf("%d\n",*(k+1));
    printf("%d\n",*(k+2));


    return 0;
}
