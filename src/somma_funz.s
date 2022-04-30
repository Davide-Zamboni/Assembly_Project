.section .data

.section .text
    .global somma_funz

.type somma_funz, @function

somma_funz:

    pushl %ebp              # salvo il base pointer per chiamate nidificate
    movl %esp, %ebp

    # salvo lo stato dei registri che verranno modificati dalla funzione
    pushl %eax
    pushl %ebx

    # recupero i parametri su cui opera la funzione dallo stack
    movl 12(%ebp), %eax
    movl 16(%ebp), %ebx

    # esegue la somma salvando risultato in ebx
    addl %eax, %ebx

    # salvo il risultato dell'operazione nella zona di memoria riservata dalla funzione chiamante
    movl %ebx, 8(%ebp)

    # scarico lo stack
    popl %ebx
    popl %eax
    popl %ebp

    ret
