.section .data

.section .text
    .global moltiplicazione_funz

.type moltiplicazione_funz, @function

moltiplicazione_funz:

    pushl %ebp          # salvo ebp per eventuali chiamate nidificate
    movl %esp, %ebp

    # salvo lo stato dei registri che verranno modificati dalla funzione
    pushl %eax
    pushl %ebx

    # recupero i parametri su cui opera la funzione dallo stack
    movl 12(%ebp), %ebx
    movl 16(%ebp), %eax

    # imul esegue eax * ebx e salva in eax
    imul %ebx

    # salvo il risultato dell'operazione nella zona di memoria riservata dalla funzione chiamante
    movl %eax, 8(%ebp)

    popl %ebx
    popl %eax
    popl %ebp

    ret
    