.data

risultato_tmp:          #variabile dove verrà salvaro temporaneamente il risultato
    .long 0

negativo_flag:          # flag che diventa 1 quando e' stato letto un numero negativo
    .int 1

 stack_counter:         #contatore degli elementi aggiunti sullo stack
    .long 0

.text 
    .global postfix
     
postfix: 

    pushl %ebp                # salvataggio per eventuali chiamate nidificate
    movl %esp, %ebp           

    movl 8(%ebp), %esi        # salviamo il primo elemento della stringa di input in esi
    movl 12(%ebp), %edi       # salviamo la destinazione della stringa in output in edi
    
    # salviamo lo stato dei registri 
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx

    movl $0, %eax			 # azzero il registro eax
	movl $0, %ecx            # azzero il contatore
  	movl $0, %ebx            # azzero il registro EBX
    movl $0, negativo_flag   # azzero il negativo_flag

# Prima acquisizione (controlliamo che il primo carattere sia necessariamente un numero oppure il segno meno)
first_loop:
    movb (%ecx,%esi,1), %bl  #salva il primo carattere in bl

    cmp $45, %bl   #carattere letto = '-'
    je first_meno

    cmp $48, %bl   #carattere letto = '0'
    je continua
    jl invalid_character      # se il numero è più piccolo del corrispondente a 0 non è valido

    cmp $57, %bl   # carattere letto = '9'
    je continua     # se è <= continua a leggere
    jl continua     
    jg invalid_character     # il numero non è valido

# continuo l'acquisizione
loop: 
    movb (%ecx,%esi,1), %bl   # carico il valore ASCII in bl

    # andata a capo opzionale
    cmp $10, %bl             # se leggo il carattere \0  o \n inizia l'algoritmo
    je salvataggio_output
    
    cmp $0, %bl
	je salvataggio_output

    cmp $32, %bl              # ho letto uno spazio
    je increment_number

    # lettura di carattere diverso da segno o numero
    cmp $42, %bl   #carattere letto = '*'
    je pre_prodotto

    cmp $43, %bl   #carattere letto = '+'
    je pre_somma

    cmp $47, %bl   #carattere letto = '/'
    je pre_divisione 

    cmp $45, %bl  #carattere letto = '-'
    je gestione_meno

    cmp $48, %bl   #carattere letto = '0'
    je continua
    jl invalid_character      # se il numero è più piccolo del corrispondente a 0 non è valido

    cmp $57, %bl   # carattere letto = '9'
    je continua     # se è <= continua a leggere
    jl continua     
    jg invalid_character     # il numero non è valido

continua:
    # inizio a creare il mio numero e lo salvo in eax
    subl $48, %ebx
    movl $10, %edx
    mull %edx
    addl %ebx, %eax

    inc %ecx

    jmp loop    # continuo a leggere i numeri   
    
salvataggio_output:     # converte il risultato in ASCII e passa il suo indirizzo alla funzione chiamante (output)
    popl %eax
    call save_output    # output deve essere su %eax
   
    # ripristino dei registri al loro valore iniziale
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax

    movl %edi, 12(%ebp)

    popl %ebp

    ret     #ritorno al chiamante della funzione

first_meno: #se il primo carattere letto è una meno  controllo se il successivo è un numero
    inc %ecx

    movb (%ecx,%esi,1), %bl

    cmp $48, %bl               # carattere letto = '0'
    je negativo
    jl invalid_character         # se il numero è più piccolo del corrispondente a 0 non è valido

    cmp $57, %bl               # carattere letto = '9'
    je negativo                  
    jl negativo     
    jg invalid_character        # il numero non è valido

gestione_meno:  #funzione che capisce se il segno '-' è un'operazione oppure il segno di un numero
    inc %ecx

    movb (%ecx,%esi,1), %bl     # leggo il carattere successivo
    
    cmp $10, %bl                # se leggo il carattere \0  o \n devo fare una sottrazione
    je sottrazione
    
    cmp $0, %bl
	je sottrazione

    cmp $32, %bl              # ho letto uno spazio
    je sottrazione

    # se il carattere successivo al '-' e' un numero salto all' etichetta negativo
    cmp $48, %bl               # carattere letto = '0'
    je negativo
    jl invalid_character         # se il numero è più piccolo del corrispondente a 0 non è valido

    cmp $57, %bl               # carattere letto = '9'
    je negativo                  
    jl negativo     
    jg invalid_character        # il numero non è valido

negativo:
    movl $1, negativo_flag      # alzo la negativo_flag che mi servira' successivamente per rendere negativo il numero una volta finita l'acquisizione
    jmp loop

pre_somma:
    # verifico che il carattere prima e dopo l'operatore sia valido (uno spazio)
    #precedente
    dec %ecx
    movb (%ecx,%esi,1), %bl
    cmp $32, %bl
    jne invalid_character

    addl $2, %ecx                       # mi preparo per la lettura del carattere successivo
    
    movb (%ecx,%esi,1), %bl         # leggo il carattere sucessivo
    cmp $32, %bl
    je somma                         # se è uno spazio sommo

    cmp $0,  %bl                   # se  è \0 sommo
    je somma
    
    # se  è qualcos'altro vado ad invalid
    cmp $10, %bl
    jne invalid_character

somma:
    movl $0, %eax
    pushl %eax  # risultato della funzione (return)
    call somma_funz


    # decremento il numero di elementi inseriti nello stack: un operazione toglie due elementi e ne aggiunge 1
    movl stack_counter, %eax
    dec %eax
    movl %eax, stack_counter

    # dopo aver fatto l'operazione nello stack rimangono i parametri passati alla funzione:
    # vengono quindi fatte delle popl a vuoto in modo da eliminare quegli elementi, preservando
    # il risultato della funzione, che viene salvato in via temporanea in numtmp

    popl %eax
    movl %eax, risultato_tmp
    # scarico a vuoto gli operandi dell'operazione
    popl %eax
    popl %eax
    
    #rimetto il risultato temporaneo nello stack
    movl risultato_tmp, %eax
    pushl %eax

    movl $0, %eax                   # azzero i regisrti utilizzati
    movl $0, %ebx

    jmp loop

# il controllo della sottrazione e' gia stato fatto precedentemente in gestione_meno, quindi eseguo la sottrazione
sottrazione:
    subl $2, %ecx
    movb (%ecx,%esi,1), %bl
    cmp $32, %bl
    jne invalid_character

    addl $2, %ecx

    movl $0, %eax
    pushl %eax
    call sottrazione_funz

    # decremento il numero di elementi inseriti nello stack: un operazione toglie due elementi e ne aggiunge 1
    movl stack_counter, %eax
    dec %eax
    movl %eax, stack_counter
    
    
    # dopo aver fatto l'operazione nello stack rimangono i parametri passati alla funzione:
    # vengono quindi fatte delle popl a vuoto in modo da eliminare quegli elementi, preservando
    # il risultato della funzione, che viene salvato in via temporanea in numtmp
    
    popl %eax
    movl %eax, risultato_tmp
    # scarico i parametri dell'operazione
    popl %eax
    popl %eax
    # ripristino il risultato temporaneo nello stack
    movl risultato_tmp, %eax
    pushl %eax

    #azzero i registri
    movl $0, %eax
    movl $0, %ebx

    jmp loop

pre_divisione: 
    # verifico che il carattere dopo l'operatore sia valido
    dec %ecx
    movb (%ecx,%esi,1), %bl
    cmp $32, %bl
    jne invalid_character

    addl $2, %ecx                    # mi preparo per la lettura del carattere successivo
    movb (%ecx,%esi,1), %bl         # leggo il carattere sucessivo

    cmp $32, %bl
    je divisione                    # se è uno spazio divido

    cmp $0,  %bl                  # se  è \0 divido
    je divisione
   
    cmp $10, %bl
    jne invalid_character

divisione:                          
    popl %ebx                       # recupero gli elementi da dividere
    popl %eax

    cmp $0, %eax                    # controllo che il dividendo non sia negativo
    jl divisione_invalid        
    cmp $0, %ebx                    # controllo la divisione per 0
    je divisione_invalid
    idiv  %ebx                      # eseguo la divisione tra eax ed ebx
   
    pushl %eax                      # le cifre significative sono in eax

    # decremento il numero di elementi inseriti nello stack: un operazione toglie due elementi e ne aggiunge 1
    movl stack_counter, %eax
    dec %eax
    movl %eax, stack_counter

    movl $0, %eax                   
    movl $0, %ebx

    jmp loop

divisione_invalid:
    movl stack_counter, %eax
    subl $2, %eax
    movl %eax, stack_counter
    jmp invalid_character

pre_prodotto:
    # verifico che il carattere dopo l'operatore sia valido
    dec %ecx
    movb (%ecx,%esi,1), %bl
    cmp $32, %bl
    jne invalid_character

    addl $2, %ecx                   # mi preparo per la lettura del carattere successivo
    movb (%ecx,%esi,1), %bl         # leggo il carattere sucessivo

    cmp $32, %bl
    je prodotto                     # se è uno spazio moltiplico

    cmp $0,  %bl                   # se  è \0 moltiplico
    je prodotto
    cmp $10, %bl
    jne invalid_character

prodotto:   
    movl $0, %eax   # valore di ritorno della funzione prodotto
    pushl %eax
    call moltiplicazione_funz


    # decremento il numero di elementi inseriti nello stack: un operazione toglie due elementi e ne aggiunge 1
    movl stack_counter, %eax
    dec %eax
    movl %eax, stack_counter

    
    #  dopo aver fatto l'operazione nello stack rimangono i parametri passati alla funzione:
    #  vengono quindi fatte delle popl a vuoto in modo da eliminare quegli elementi, preservando
    #  il risultato della funzione, che viene salvato in via temporanea in numtmp

    popl %eax
    movl %eax, risultato_tmp
    popl %eax
    popl %eax
    movl risultato_tmp, %eax
    pushl %eax

    movl $0, %eax                   
    movl $0, %ebx

    jmp loop


invalid_character:
    movl stack_counter, %ecx
    cmpl $0, %ecx
    je continua_invalid

scarica_stack: 
    popl %eax
    xorl %eax, %eax

    loop scarica_stack

continua_invalid:
    movl $7, %ecx
    movl $0, %ebx

    call invalid

    popl %edx
    popl %ecx
    popl %ebx
    popl %eax

    movl %edi, 12(%ebp)

    popl %ebp

    ret

# rende il numero da positivo a negativo
postoneg:
    movl $0, %ebx
    subl %eax, %ebx            # sottraggo a 0 il numero positivo
    movl %ebx, %eax            # salvo il risultato in eax

    movl $0, negativo_flag

    jmp increment

increment_number: # mi salvo il valore del numero letto nello stack
    dec %ecx # mi preparo per la lettura del carattere precedente
                                    
    movb (%ecx,%esi,1), %bl    # leggo il carattere precedente

    inc %ecx
    inc %ecx

    #se il carattere precedente è un numero continuo col salvataggio altrimenti procedo con l'acquisizione
    cmp $48, %bl  #carattere letto = '0'
    je increment
    jl loop

    cmp $57, %bl   # carattere letto = '9'
    jle increment  # se è <= continua a leggere
    jg loop

increment: # salvo il numero acquisito nello stack
    movl negativo_flag, %ebx    # controllo se il negativo flag e' attivo, in quel caso converto il numero in negativo
    cmp $1, %ebx
    je  postoneg
    pushl %eax

    movl $0, %eax   #incremento il numero di elementi aggiunti allo stack
    movl stack_counter, %eax
    inc %eax
    movl %eax, stack_counter

    movl $0, %eax
    movl $0, %ebx       
   
    jmp loop  #acquisisco il numero successivo
    
