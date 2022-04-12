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
    alocaMem(13);
    heap[14]=289;
    *topoheap=358;
    printf("tamanho=%ld\n",sizeof(heap));
    printf("(1)heap[0]=%ld\n",*topoinicialheap);
    printf("(100)heap[1]=%ld\n",*(topoinicialheap+1));
    printf("(e)heap[0]=%p\n",heap);
    printf("(e)topoiniciaheap=%p\n",topoinicialheap);
    printf("(e)heap[14]=%p\n",&heap[14]);
    printf("(e)topoheap=%p\n",topoheap);
    printf("heap[14]=%ld\n",heap[14]);
    printf("topoheap=%ld\n",*topoheap);
    
    printf("--------------------------\n");
    
    
    return(0);
    

}