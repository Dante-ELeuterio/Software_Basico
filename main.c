extern long int* alocaMem();
extern void iniciaAlocador();
extern void liberaMem();
extern void finalizaAlocador();
extern void imprimeMapa();

int main(int argc, char const *argv[])
{
    iniciaAlocador();
    long int *x=alocaMem(10);
    long int *y=alocaMem(10);
    long int *z=alocaMem(10);
    long int *k=alocaMem(10);
    imprimeMapa();
    liberaMem(x);
    liberaMem(y);
    liberaMem(z);
    liberaMem(k);
    imprimeMapa();
    long int *u=alocaMem(10);
    imprimeMapa();

    finalizaAlocador();    
    return 0;
}