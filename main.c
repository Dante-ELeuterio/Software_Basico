
extern long int* alocaMem();
extern void iniciaAlocador();
extern void liberaMem();
extern void finalizaAlocador();
extern void imprimeMapa();

int main(int argc, char const *argv[])
{
    iniciaAlocador();
    imprimeMapa();
    long int *x=alocaMem(100);
    imprimeMapa();
    long int *y=alocaMem(50);
    imprimeMapa();
    liberaMem(x);
    imprimeMapa();
    long int *z=alocaMem(50);
    imprimeMapa();
    long int *k=alocaMem(34);
    imprimeMapa();

    return 0;
}
