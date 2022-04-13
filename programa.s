.section  .data
    topoHeap: .quad 0
    inicioHeap: .quad 0
    str1: .string "topoHeap %d\n"
    str2: .string "inicioHeap %d\n"

.section .text
.globl batata

iniciaAlocador:
    pushq %rbp
    movq %rsp,%rbp
    movq $12,%rax
    movq $0,%rdi
    syscall
    movq %rax,topoHeap
    movq %rax,inicioHeap
    pop %rbp
    ret
batata:
    pushq %rbp
    movq %rsp,%rbp
    call iniciaAlocador
    mov $str1,%rdi
    mov topoHeap,%rsi
    call printf
    mov $str2,%rdi
    mov inicioHeap,%rsi
    call printf
    pop %rbp
    ret

