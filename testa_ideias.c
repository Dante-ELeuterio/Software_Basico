#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>

long int heap[100];
long int *topoinicialheap;
long int *topoheap;
void iniciaAlocador()
{
    topoheap=&heap[0];
    topoinicialheap=topoheap;
    *topoheap=0;
    for (int i = 1; i < 100; i++)
        heap[i]=-1;    
}

/*void finalizaAlocador()
{

}

int liberaMem(void *bloco)
{

}*/

void* alocaMem(long int num_bytes)
{
    void *retorno=NULL;
    long int *iterador=topoinicialheap;
    if(!*topoinicialheap)
    {
        *topoheap=1;
        topoheap+=1;
        *topoheap=num_bytes;
        retorno=topoheap+1;
        topoheap+=num_bytes;
    }
    else
    {
        while (*iterador!=-1 && *iterador!=0)
        {
            iterador+=*(iterador+1)+2;
        }
        if(*iterador==-1)
            topoheap=iterador+num_bytes+1;
        *iterador=1;
        iterador+=1;
        *iterador=num_bytes;
        retorno=iterador+1;
    }

    return retorno;
}


int main(){
    iniciaAlocador();

    long int *x=alocaMem(100/8+1);
    if(!x)
    {
        printf("erro de alocação em x\n");
        return(1);
    }
    long int *y=alocaMem(100/8+1);
    if(!y)
    {
        printf("erro de alocação em y\n");
        return(1);
    }
    //testa o tamanho do vetor
    printf("tamanho=%ld\n",sizeof(heap));
    //testa se setou certo bit de ocupado e tamanho alocado
    printf("(1)heap[0]=%ld\n",*topoinicialheap);
    printf("(100)heap[1]=%ld\n",*(topoinicialheap+1));
    //testa se os endereços de heap[0] e o ponteiro pro inicio batem
    printf("(e)heap[0]=%p\n",heap);
    printf("(e)topoiniciaheap=%p\n",topoinicialheap);

    printf("--------------------------\n");


    //testa se os endereços são os mesmos e se alterar o valor de um altera o outro
    heap[2]=789;
    printf("x=%ld\n",*(x));
    printf("(e)heap[2]=%p\n",&heap[2]);
    printf("(e)x=%p\n",x);
    
    printf("--------------------------\n");

    
  
    //testa se os endereços de heap[14] e o topo da heap batem
    printf("(e)heap[28]=%p\n",&heap[28]);
    printf("(e)topoheap=%p\n",topoheap);

    //testa se os endereços são os mesmos e se alterar o valor de um altera o outro
    heap[15]=789;
    *topoheap=358;
    printf("(e)heap[15]=%p\n",&heap[15]);
    printf("(e)y=%p\n",y);
    printf("y=%ld\n",*(y));
    printf("heap[15]=%ld\n",heap[15]);
    
    return(0);
    

}