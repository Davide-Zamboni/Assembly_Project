.section .data

stringa: 
    .ascii "Invalid"

.section .text
    .global invalid

.type invalid, @function

invalid:
    pushl %ecx  #salvo i registri
    pushl %ebx

    leal stringa, %esi  #copiamo stringa da stampare in esi
copia:
    movb (%ebx,%esi,1), %al #copiamo lettera per lettera la
    movb %al, (%ebx, %edi, 1)

    inc %ebx   #indice di scorrimento di %edi[]

    loop copia

    movb $0, (%ebx,%edi,1)  #tappo in ultima posizione edi[]
    
    popl %ebx
    popl %ecx 
    
    ret

