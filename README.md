# Reverse Polish notation calculator
Programma in assembly che legge in input una stringa rappresentante un’espressione ben formata in numero di operandi e operazioni in RPN (si considerino solo gli operatori + - * /) e scriva in output il risultato ottenuto dalla valutazione dell’espressione.
Le espressioni che verranno usate per testare il progetto hanno i seguenti vincoli:

- Gli operatori considerati sono i 4 fondamentali e codificati con i seguenti simboli:  
+ Addizione
* Moltiplicazione (non x)
- Sottrazione 
/ Divisione (non \)  

- Un operando può essere composto da più cifre intere con segno ( 10, -327, 5670)
- Solo gli operandi negativi hanno il segno riportato esplicitamente in testa.
- Gli operandi hanno un valore massimo codificabile in 32-bit.
- Il risultato di una moltiplicazione o di una divisione può essere codificato al   massimo in 32-bit.
- Il risultato di una divisione dà sempre risultati interi, quindi senza resto.
- Il dividendo di una divisione delle istanze utilizzate è sempre positivo, mentre il divisore può essere negativo.
- Tra ogni operatore e/o operando vi è uno spazio che li separa.
- L’ultimo operatore dell’espressione è seguito dal simbolo di fine stringa “\0”.
- Le espressioni NON hanno limite di lunghezza.  
- L’eseguibile generato si dovrà chiamare postfix
- Non è consentito l’utilizzo di chiamate a funzioni descritte in altri linguaggi all’interno del codice Assembly.
Se le stringhe inserite non sono valide (contengono simboli che non sono operatori o numeri) il programma deve restituire la stringa scritta esattamente nel seguente modo: Invalid
Non verranno fatti test con stringhe il cui numero di operandi non coincide con il numero di operatori.
