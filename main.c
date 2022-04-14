#include <stdio.h>

extern long int* alocaMem();
extern void iniciaAlocador();
int main(int argc, char const *argv[])
{
    iniciaAlocador();
    long int *x=alocaMem(1000);
    printf("%d\n",x);
    printf("%d\n",*(x+1));
    printf("%d\n",*(x+2));
    
    long int *y=alocaMem(500);
    printf("%d\n",y);
    printf("%d\n",*(y+1));
    printf("%d\n",*(y+2));
    return 0;
}
