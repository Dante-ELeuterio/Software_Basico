.section  .data
    TOPO_HEAP: .quad 0                  #Ponteiro para o topo da Heap, nesse momento ela está vazia
    INICIO_HEAP: .quad 0                #Ponteiro fixo para o início da heap
    ANDARILHO: .quad 0                  #Ponteiro que caminha pela heap em alocaMem
    MAIOR: .quad 0                      #Variavel para guardar o maior espaço livre encontrado
    BYTES_A_ALOCAR: .quad 0             #Guarda o numero de bytes a alocar
    ENDEREÇO_A_DESALOCAR: .quad 0       #Guarda o endereço da variavel a dar free
    NODO_JUNCAO: .quad 0                #Guarda o nodo em que será feita a junção

    livre: .string "-"
    ocupado: .string "+"
    mapa_vazio: .string "\nMapa vazio\n\n"
    bytesFlags: .string "################"
    str2: .string "\n\n"
    str4: .string "API para alocação de mémoria em Assembly\n\n"


.section .text
.globl alocaMem 
.globl iniciaAlocador
.globl liberaMem
.globl finalizaAlocador
.globl imprimeMapa

iniciaAlocador:
    pushq %rbp
    movq %rsp,%rbp
    movq $str4,%rdi
    call printf
    movq $12,%rax
    movq $0,%rdi                        #Passa 0 para %rdi para se retornar o valor de brk em %rax
    syscall
    movq %rax,TOPO_HEAP                 #Passa os valores de brk para as variáveis globais
    movq %rax,INICIO_HEAP                
    pop %rbp
    ret


alocaMem:
    pushq %rbp
    movq %rsp,%rbp
    movq %rdi, BYTES_A_ALOCAR
    movq $0,MAIOR
    movq INICIO_HEAP, %rax
    movq %rax,%rbx
    addq $16,%rbx                  
    movq %rbx, ANDARILHO                #Ponteiro que caminha pela heap recebe o começo da Heap
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da Heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria

    AchaLivre:
    movq ANDARILHO, %rax                #%rax == ANDARILHO
    movq -16(%rax), %rbx                #ANDARILHO + 8 e onde esta armazenado o sinal de ocupado ou livre
    cmpq $0, %rbx                       #Confere o sinal, se livre, pula para ver se o tamanho e compativel
    je ConfereTamanho
    Else:
    movq ANDARILHO,%rax
    movq -8(%rax), %rbx                 #%rbx recebe o tamanho do espaco alocado no nodo
    addq %rbx, %rax
    addq $16, %rax                      #%rax desloca o tamanho do espaco alocado + 16 bytes
    movq %rax, ANDARILHO                #ANDARILHO se desloca para o proximo nodo
    movq TOPO_HEAP, %rbx                #Verifica se ANDARILHO chegou no topo da heap
    cmpq %rbx, %rax                     
    jl AchaLivre
    cmpq $0,MAIOR
    je AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
    movq MAIOR,%rax
    movq -8(%rax),%rbx
    movq BYTES_A_ALOCAR,%rax
    cmpq %rax,%rbx
    je IGUAL
    jmp MENOR

    ConfereTamanho:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx                #Compara a quantidade de bytes a alocar com o tamanho do bloco vazio encontrado
    movq BYTES_A_ALOCAR, %rax
    addq $16,%rax                      #Confere se tem espaço contando os 16 bytes das flag
    cmpq %rbx, %rax
    jge  Else                          #Se não tem espaço volta a procurar novo nodo
    cmpq %rbx,MAIOR
    jge  Else
    movq ANDARILHO,%rax
    movq %rax,MAIOR
    jmp Else

    MENOR:
    movq MAIOR, %rax                #Tem espaço,aloca aqui mesmo
    movq BYTES_A_ALOCAR, %rcx
    movq $1,-16(%rax)
    movq %rcx, -8(%rax)
    movq %rcx, %rax
    subq %rax, %rbx                     
    movq MAIOR, %rax
    movq BYTES_A_ALOCAR,%rcx
    addq %rcx, %rax
    addq $16,%rax                       #Desloca pro nodo livre novo contendo os bytes restantes
    movq $0, -16(%rax)                  #Cria o nodo novo
    subq $16, %rbx
    movq %rbx, -8(%rax)
    movq MAIOR, %rax
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

    IGUAL:                              #Tem exatamente o espaço pra alocar  
    movq MAIOR, %rax                
    movq BYTES_A_ALOCAR, %rcx
    movq $1,-16(%rax)
    movq %rcx, -8(%rax)
    movq MAIOR, %rax
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

    AlocaEspacoNovo:
    movq BYTES_A_ALOCAR,%rbx
    addq $16, %rbx
    addq TOPO_HEAP, %rbx
    movq $12, %rax
    movq %rbx, %rdi
    syscall
    movq %rax, TOPO_HEAP
    movq ANDARILHO, %rax
    movq $1, -16(%rax)                  #Seta o sinal de ocupado no novo espaço alocado
    movq BYTES_A_ALOCAR, %rbx           #Armazena o tamanho do bloco no campo de tamanho em ANDARILHO + 16 bytes
    movq %rbx, -8(%rax)
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

liberaMem:
    pushq %rbp
    movq %rsp,%rbp    
    movq %rdi,ENDEREÇO_A_DESALOCAR
    movq ENDEREÇO_A_DESALOCAR,%rax      #rax recebe a posição exata de memória que deseja liberar
    movq $0,-16(%rax)                   #Seta como livre a flag
    movq INICIO_HEAP, %rax
    addq $16, %rax
    movq %rax, ANDARILHO                
    JuntaNodos:                         #Laço que caminha pela Heap, quando encontra endereço livre faz a junção
    movq ANDARILHO, %rax
    movq %rax, NODO_JUNCAO
    movq -16(%rax), %rbx
    cmpq $0, %rbx
    je Juncao                           #Se o nodo estiver livre, Realiza a junção até encontrar o primeiro ocupado
    movq -8(%rax), %rbx
    addq $16, %rbx
    addq %rbx, %rax                     #Desloca para o próximo nodo
    cmpq TOPO_HEAP, %rax
    jge FimDesaloca
    movq %rax, ANDARILHO
    jmp JuntaNodos

    Juncao:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx
    addq $16, %rbx
    addq %rbx, %rax                     #Desloca para o próximo nodo
    cmpq TOPO_HEAP, %rax                
    jge VoltaBRK                        #Compara para ver se chegou ao final
    movq %rax, ANDARILHO
    movq -16(%rax), %rbx
    cmpq $0, %rbx                       #Se o próximo nodo não estiver livre, não realiza a juncao
    jne JuntaNodos
    movq -8(%rax), %rbx
    addq $16, %rbx                      #Soma 16 Bytes na quantidade alocada no nodo livre   
    movq NODO_JUNCAO, %rax
    movq -8(%rax), %rcx
    addq %rbx, %rcx                     
    movq %rcx, -8(%rax)                 #Realiza a junção, soma as quantidades alocadas + 16 e guarda no primeiro livre
    jmp Juncao
    
    VoltaBRK:                           #Liberou o ultimo nodo,volta a brk
    movq NODO_JUNCAO,%rax
    subq $16,%rax
    movq %rax,TOPO_HEAP
    movq $12,%rax
    movq TOPO_HEAP,%rdi
    syscall


    FimDesaloca:
    popq %rbp
    ret
    
finalizaAlocador:
    pushq %rbp
    movq %rsp,%rbp
    movq $12, %rax
    movq INICIO_HEAP, %rdi              #Restaura a brk para o endereço original
    syscall
    popq %rbp
    ret

imprimeMapa:
    pushq %rbp
    movq %rsp,%rbp
    
    movq TOPO_HEAP,%rax                 
    cmpq %rax,INICIO_HEAP               #Confere se o mapa está vazio para evitar segfault
    jne  imprime
    mov $mapa_vazio,%rdi
    call printf
    popq %rbp
    ret
    
    imprime:
    movq INICIO_HEAP, %rax              #Coloca o inicio da heap em rax
    addq $16, %rax                      #Desloca o rax pra primeira variavel
    movq %rax, ANDARILHO
    loop:
    mov $bytesFlags,%rdi
    call printf
    movq ANDARILHO, %rax                #restaura %rax com o ANDARILHO
    movq -16(%rax), %rbx                #Coloca a flag de ocupado ou livre em %rbx
    cmpq $0, %rbx                       #Confere se está ocupado ou livre
    je  imprimeLivre                    #se estiver livre imprime - vezes o número de bytes livres
    jne imprimeOcupado                  #se estiver ocupado imprime + vees o número de bytes ocupados

    imprimeLivre:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx                 #Move a quantidade de bytes ocupados para %rbx
    loopLivre:                          #Parte do código que imprime o sinal de ocupado ou livre n vezes
    mov $livre, %rdi
    call printf
    subq $1, %rbx                       #Subtrai %rbx em 1 até chegar em 0, para imprimir os n bytes
    cmpq $0, %rbx
    jg loopLivre                        #Enquanto %rbx for menor que 0 continua no loop
    movq ANDARILHO, %rax                #Restaura %rax
    movq -8(%rax), %rbx                 
    addq $16, %rbx
    addq %rbx, ANDARILHO                #desloca para o próximo nodo
    movq ANDARILHO,%rbx
    cmpq TOPO_HEAP, %rbx                #Confere se alcançou o fim da heap
    jl  loop
    jmp final

    imprimeOcupado:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx                 #Move a quantidade de bytes ocupados para %rbx
    loopOcupado:                        #Parte do código que imprime o sinal de ocupado ou livre n vezes
    mov $ocupado, %rdi
    call printf                         
    subq $1, %rbx                       #Subtrai %rbx em 1 até chegar em 0, para imprimir os n bytes
    cmpq $0, %rbx
    jg loopOcupado                      #Enquanto %rbx for menor que 0 continua no loop
    movq ANDARILHO, %rax                #Restaura %rax
    movq -8(%rax), %rbx                 
    addq $16, %rbx
    addq %rbx, ANDARILHO                #desloca para o próximo nodo
    movq ANDARILHO,%rbx
    cmpq TOPO_HEAP, %rbx                #Confere se alcançou o fim da heap
    jl  loop
    jmp final

    final:
    movq $str2,%rdi
    call printf
    popq %rbp
    ret



