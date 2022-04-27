.section  .data
    TOPO_HEAP: .quad 0                  #Ponteiro para o topo da Heap, nesse momento ela está vazia
    INICIO_HEAP: .quad 0                #Ponteiro fixo para o início da heap
    ANDARILHO: .quad 0                  #Ponteiro que caminha pela heap em alocaMem
    BYTES_A_ALOCAR: .quad 0             #Guarda o numero de bytes a alocar
    ENDEREÇO_A_DESALOCAR: .quad 0       #Guarda o endereço da variavel a dar free
    NODO_JUNCAO: .quad 0                #Guarda o nodo em que será feita a junção
    ALOCOU: .quad 0                     #Flag pra não imprimir vazio

    livre: .string "+ "
    ocupado: .string "- "
    bytesLivres: .string "%ld "
    barra: .string "| "
    mapa_vazio: .string "Mapa vazio\n-----------------------------------------------------------\n"
    str1: .string "***| "
    str2: .string "\n"
    str3: .string "-----------------------------------------------------------\n"
    str4: .string "API para alocação de mémoria em Assembly\n"

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
    movq $str3,%rdi
    call printf                         #Strings de inicio do codigo
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
    movq $1,ALOCOU                      #Flag para evitar segfault se alguem tentar imprimir sem ter alocado nada
    movq %rdi, BYTES_A_ALOCAR
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
    #addq $8, %rax
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
    jmp AchaLivre

    ConfereTamanho:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx                #Compara a quantidade de bytes a alocar com o tamanho do bloco vazio encontrado
    movq BYTES_A_ALOCAR, %rax
    cmpq %rbx, %rax
    je IGUAL                           #Se for igual pode alocar sem preocupar com criar um novo nodo vazio com 16 bytes de flag
    addq $16,%rax                      #Confere se tem espaço contando os 16 bytes das flag
    cmpq %rbx, %rax
    jg Else                            #Se não tem espaço volta a procurar novo nodo
    
    MENOR:
    movq ANDARILHO, %rax                #Tem espaço,aloca aqui mesmo
    movq BYTES_A_ALOCAR, %rcx
    movq $1,-16(%rax)
    movq %rcx, -8(%rax)
    movq %rcx, %rax
    subq %rax, %rbx                     
    movq ANDARILHO, %rax
    movq BYTES_A_ALOCAR,%rcx
    addq %rcx, %rax
    addq $16,%rax                       #Desloca pro nodo livre novo contendo os bytes restantes
    movq $0, -16(%rax)                  #Cria o nodo novo
    subq $16, %rbx
    movq %rbx, -8(%rax)
    movq ANDARILHO, %rax
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax
    
    IGUAL:                              #Tem exatamente o espaço pra alocar  
    movq ANDARILHO, %rax                
    movq BYTES_A_ALOCAR, %rcx
    movq $1,-16(%rax)
    movq %rcx, -8(%rax)
    movq ANDARILHO, %rax
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
    jge FimDesaloca                     #Compara para ver se chegou ao final
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
    
    movq ALOCOU,%rax                    #Se nunca tiver alocado nada,imprime mensagem de erro e retorna pra main(evitar segfault)
    cmpq $1,%rax
    je  imprime
    mov $mapa_vazio,%rdi
    call printf
    popq %rbp
    ret
    
    imprime:
    mov  $barra,%rdi                    #Imprime uma barra no inicio
    call printf
    movq INICIO_HEAP, %rax              #Coloca o inicio da heap em rax
    addq $16, %rax                      #Desloca o rax pra primeira variavel
    movq %rax, ANDARILHO
    loop:
    movq ANDARILHO, %rax                #restaura %rax com o ANDARILHO
    movq -16(%rax), %rbx                #Coloca a flag de ocupado ou livre em %rbx
    cmpq $0, %rbx                       #Confere se está ocupado ou livre
    je  imprimeLivre                    #se estiver livre imprime +
    jne imprimeOcupado                  #se estiver ocupado imprime -
    imprimeBytes:                       #imprime a quantidade de bytes livres
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx                 #Coloca o número de bytes do bloco em %rbx
    mov $bytesLivres, %rdi
    movq %rbx, %rsi
    call printf                         #Imprime a quantidade de bytes do bloco
    mov $str1, %rdi                     #Imprime os simbolso para demonstrar os bytes
    call printf
    movq ANDARILHO, %rax                #Restaura %rax
    movq -8(%rax), %rbx                 
    addq $16, %rbx
    addq %rbx, ANDARILHO                #desloca para o próximo nodo
    movq ANDARILHO,%rbx
    cmpq TOPO_HEAP, %rbx                #Confere se alcançou o fim da heap
    jl  loop                            
    mov $str2, %rdi                     #Pula a linha e coloca uma ultima fileira de "-------" para acabar a impressão
    call printf
    movq $str3,%rdi
    call printf
    popq %rbp
    ret

    imprimeLivre:
    mov $livre, %rdi
    call printf
    jmp imprimeBytes

    imprimeOcupado:
    mov $ocupado, %rdi
    call printf
    jmp imprimeBytes

