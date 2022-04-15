.section  .data
    TOPO_HEAP: .quad 0                  #Ponteiro para o topo da Heap, nesse momento ela está vazia
    INICIO_HEAP: .quad 0                #Ponteiro fixo para o início da heap
    ANDARILHO: .quad 0                  #Ponteiro que caminha pela heap em alocaMem
    BYTES_A_ALOCAR: .quad 0             #Guarda o numero de bytes a alocar
    ENDEREÇO_A_DESALOCAR: .quad 0       #Guarda o endereço da variavel a dar free

    str1: .string "TOPO_HEAP %d\n"
    str2: .string "INICIO_HEAP %d\n"
    str3: .string "PONTEIRO DA MEMORIA ALOCADA %d\n"
    strteste: .string "TESTE:%d\n"
.section .text
.globl alocaMem 
.globl iniciaAlocador
.globl liberaMem

iniciaAlocador:
    pushq %rbp
    movq %rsp,%rbp
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
    movq INICIO_HEAP, %rax
    movq %rax,%rbx
    addq $24,%rbx                  
    movq %rbx, ANDARILHO                #Ponteiro que caminha pela heap recebe o começo da Heap
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da Heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
 
    AchaLivre:
    movq ANDARILHO, %rax                #%rax == ANDARILHO
    movq -16(%rax), %rbx                  #ANDARILHO + 8 e onde esta armazenado o sinal de ocupado ou livre
    cmpq $0, %rbx                       #Confere o sinal, se livre, pula para ver se o tamanho e compativel
    je ConfereTamanho
    Else:
    movq ANDARILHO,%rax
    movq -8(%rax), %rbx                 #%rbx recebe o tamanho do espaco alocado no nodo
    addq %rbx, %rax
    addq $16, %rax                      #%rax desloca o tamanho do espaco alocado + 16 bytes
    movq %rax, ANDARILHO                #ANDARILHO se desloca para o proximo nodo
    movq ANDARILHO, %rax
    addq $8, %rax
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
    jmp AchaLivre

    ConfereTamanho:
    movq ANDARILHO, %rax
    movq -8(%rax), %rbx
    movq BYTES_A_ALOCAR, %rax
    #addq $16,%rax                       #Confere se tem espaço contando os 16 bytes das flag
    cmpq %rbx, %rax
    jg Else                                
    movq ANDARILHO, %rax                #Tem espaço,aloca aqui mesmo
    movq BYTES_A_ALOCAR, %rcx
    movq $1,-16(%rax)
    movq %rcx, -8(%rax)
    movq %rcx, %rax
    subq %rax, %rbx                     
    addq $16, %rbx                      
    movq ANDARILHO, %rax
    addq %rbx, %rax                     #Desloca pro nodo livre novo contendo os bytes restantes
    movq $0, -16(%rax)
    subq $32, %rbx
    movq %rbx, -8(%rax)
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
    movq $1, -16(%rax)                    #Seta o sinal de ocupado no novo espaço alocado
    movq BYTES_A_ALOCAR, %rbx           #Armazena o tamanho do bloco no campo de tamanho em ANDARILHO + 16 bytes
    movq %rbx, -8(%rax)
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

liberaMem:
    pushq %rbp
    movq %rsp,%rbp    
    movq %rdi,ENDEREÇO_A_DESALOCAR
    movq ENDEREÇO_A_DESALOCAR,%rax
    movq $0,-16(%rax)
    popq %rbp
    ret

