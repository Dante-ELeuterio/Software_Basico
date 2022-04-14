.section  .data
    TOPO_HEAP: .quad 0                  #Ponteiro para o topo da Heap, nesse momento ela está vazia
    INICIO_HEAP: .quad 0                #Ponteiro fixo para o início da heap
    ANDARILHO: .quad 0                  #Ponteiro que caminha pela heap em alocaMem

    str1: .string "TOPO_HEAP %d\n"
    str2: .string "INICIO_HEAP %d\n"
    str3: .string "PONTEIRO DA MEMORIA ALOCADA %d\n"

.section .text
.globl batata

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
    movq INICIO_HEAP, %rax              #Ponteiro que caminha pela heap recebe o começo da Heap
    movq %rax, ANDARILHO
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da Heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
 
    AchaLivre:
    movq ANDARILHO, %rax                #%rax == ANDARILHO
    movq 8(%rax), %rbx                  #ANDARILHO + 8 e onde esta armazenado o sinal de ocupado ou livre
    cmpq $0, %rbx                       #Confere o sinal, se livre, pula para ver se o tamanho e compativel
    je ConfereTamanho
    Else:
    movq 16(%rax), %rbx                 #%rbx recebe o tamanho do espaco alocado no nodo
    addq %rbx, %rax
    addq $16, %rax                      #%rax desloca o tamanho do espaco alocado + 16 bytes
    addq %rax, ANDARILHO                #ANDARILHO se desloca para o proximo nodo
    movq ANDARILHO, %rax
    addq $8, %rax
    movq TOPO_HEAP, %rbx
    cmpq %rbx, %rax                     #Verifica se ANDARILHO chegou no topo da heap
    jge AlocaEspacoNovo                 #Se sim aloca um novo bloco de memoria
    jmp AchaLivre

    ConfereTamanho:
    movq ANDARILHO, %rax
    movq 16(%rax), %rbx
    movq 16(%rbp), %rax
    cmpq %rbx, %rax
    jg Else
    movq ANDARILHO, %rax                #pendencia de implementar no caso de nao ter espaco para as flags
    movq 16(%rbp), %rcx
    movq %rcx, 16(%rax)
    movq 16(%rbp), %rax
    subq %rax, %rbx
    addq $16, %rbx
    movq ANDARILHO, %rax
    addq %rbx, %rax
    movq $0, 8(%rax)
    subq $16, %rbx
    movq %rbx, 16(%rax)
    movq ANDARILHO, %rax
    movq INICIO_HEAP, %rbx
    movq %rbx, ANDARILHO
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

    AlocaEspacoNovo:
    movq 16(%rbp), %rbx
    addq $16, %rbx
    addq TOPO_HEAP, %rbx
    movq $12, %rax
    movq %rbx, %rdi
    syscall
    movq %rbx, TOPO_HEAP
    movq ANDARILHO, %rax
    movq $1, 8(%rax)                    #Seta o sinal de livre no novo espaço alocado
    movq 16(%rbp), %rbx                 #Armazena o tamanho do bloco no campo de tamanho em ANDARILHO + 16 bytes
    movq %rbx, 16(%rax)
    movq INICIO_HEAP, %rbx
    movq %rbx, ANDARILHO
    pop %rbp
    ret                                 #Retorna para a main com o valor do endereco alocado em %rax

batata:
    pushq %rbp
    movq %rsp,%rbp
    call iniciaAlocador
    mov $str1,%rdi
    mov TOPO_HEAP,%rsi
    call printf
    mov $str2,%rdi
    mov INICIO_HEAP,%rsi
    call printf

    pushq $1000                         #Teste de alocaMem(1000)
    call alocaMem
    mov $str1,%rdi
    mov TOPO_HEAP,%rsi
    call printf
    mov $str3, %rdi
    mov %rax, %rsi
    call printf

    pop %rbp
    ret

