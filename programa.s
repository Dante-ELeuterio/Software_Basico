.section  .data
    topoHeap: .quad
    inicioHeap: .quad
    str1: .string "topoHeap %d\n"
    str2: .string "inicioHeap %d\n"
.section .text
.globl _start
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
_start:
    call iniciaAlocador
    mov $str1,%rdi
    movq inicioHeap,%rsi
    movq $1,%rax
    syscall
    mov $str2,%rdi
    movq topoHeap,%rsi
    movq $1,%rax
    syscall
    movq $60,%rax
    syscall