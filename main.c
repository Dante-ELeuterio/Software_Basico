
extern long int* alocaMem();
extern void iniciaAlocador();
extern void liberaMem();
extern void finalizaAlocador();
extern void imprimeMapa();

int main(int argc, char const *argv[])
{
    iniciaAlocador();
    long int *x=alocaMem(1000);
    imprimeMapa();
    long int *y=alocaMem(500);
    imprimeMapa();
    liberaMem(x);
    imprimeMapa();
    long int *z=alocaMem(500);
    imprimeMapa();
    long int *k=alocaMem(450);
    imprimeMapa();
    long int *j=alocaMem(18);
    imprimeMapa();

    


    return 0;
}
