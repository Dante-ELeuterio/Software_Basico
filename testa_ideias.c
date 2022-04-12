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
}

/*void finalizaAlocador()
{

}

int liberaMem(void *bloco)
{

}*/

void* alocaMem(long int num_bytes)
{
    void *retorno;
    *topoheap=1;
    topoheap+=1;
    *topoheap=num_bytes;
    retorno=topoheap+1;
    topoheap+=num_bytes;
    return retorno;
}


int main(){
    for (int i = 0; i < 100; i++)
        heap[i]=0;    
    iniciaAlocador();

    long int *x=alocaMem(100/8+1);
    heap[3]=789;
    *topoheap=358;

    //testa o tamanho do vetor
    printf("tamanho=%ld\n",sizeof(heap));
    //testa se setou certo bit de ocupado e tamanho alocado
    printf("(1)heap[0]=%ld\n",*topoinicialheap);
    printf("(100)heap[1]=%ld\n",*(topoinicialheap+1));
    //testa se os endereços de heap[0] e o ponteiro pro inicio batem
    printf("(e)heap[0]=%p\n",heap);
    printf("(e)topoiniciaheap=%p\n",topoinicialheap);
    //testa se os endereços de heap[2] e x batem
    printf("(e)heap[2]=%p\n",&heap[2]);
    printf("(e)x=%p\n",x);
    //testa se os endereços de heap[14] e o topo da heap batem
    printf("(e)heap[14]=%p\n",&heap[14]);
    printf("(e)topoheap=%p\n",topoheap);

    //testa se os endereços são os mesmos e se alterar o valor de um altera o outro
    heap[3]=789;
    *topoheap=358;
    printf("x=%ld\n",*(x+1));
    printf("heap[14]=%ld\n",heap[14]);
    printf("topoheap=%ld\n",*topoheap);
    
    printf("--------------------------\n");
    
    
    return(0);
    

}