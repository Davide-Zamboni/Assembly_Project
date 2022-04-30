.section .data

numtmp:
    .ascii "000000000000"

negativo_flag:                  #flag che si alza qualora il numero dia negativo
    .int 1

.section .text
    .global save_output

.type save_output, @function

save_output:
    movl $0, negativo_flag  #azzero il negativo_flag
    cmp $0, %eax            #se il numero è negativo salto alla funzione che mi converte il numero in positivo
    jl positivo

#inizio a convertire il numero in ASCII
save:
    pushl %ebx
    pushl %ecx

    movl $10, %ebx
    movl $0, %ecx

    leal numtmp, %esi

#continuo a prendere l'ultima cifra del numero e la converto in ASCII
continua_a_dividere:
    movl $0, %edx
    divl %ebx

    addb $48, %dl
    movb %dl, (%ecx,%esi,1)

    inc %ecx
    
    cmp $0, %eax

    jne continua_a_dividere

    movl $0,%ebx
    
    #verifico se il flag negativo è stato alzato e in quel caso salto a segno
    movl negativo_flag, %edx
    cmp $1, %edx
    je segno

#poichè la stringa è stata salvata al contrario la ribalto
ribalta_stringa: 
    
    movb -1(%ecx,%esi,1), %al

    movb %al, (%ebx,%edi,1)

    inc %ebx

    loop ribalta_stringa

#salvo la stringa
salva: 
    movb $0, (%ebx,%edi,1)

    popl %ecx
    popl %ebx

    ret
#converte il numero in positivo ed alza il negativo_flag
positivo:
    movl $0, %ebx
    subl %eax,%ebx
    movl %ebx,%eax
    movl $1, negativo_flag
    jmp save
# aggiungo il carattere '-' alla stringa
segno:
    movb $45, (%ebx,%edi,1)
    inc %ebx

    jmp ribalta_stringa
