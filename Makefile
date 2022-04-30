
AS_FLAGS= --32
LD_FLAGS=-g -m32 
DEBUG= -gstabs
FILENAME=postfix

all: bin/$(FILENAME)
	@echo Done!

bin/$(FILENAME): obj/$(FILENAME).o obj/invalid.o obj/save_output.o obj/somma_funz.o obj/sottrazione_funz.o obj/moltiplicazione_funz.o
	@echo Linking...
	gcc $(LD_FLAGS) $(DEBUG) src/main.c obj/$(FILENAME).o obj/invalid.o obj/save_output.o obj/somma_funz.o obj/sottrazione_funz.o obj/moltiplicazione_funz.o -o bin/$(FILENAME)

obj/$(FILENAME).o: src/$(FILENAME).s
	@echo Assembling...
	@as $(AS_FLAGS) $(DEBUG) src/$(FILENAME).s -o obj/$(FILENAME).o

obj/invalid.o: src/invalid.s
	@echo Assembling invalid...
	@as $(AS_FLAGS) $(DEBUG) src/invalid.s -o obj/invalid.o


obj/save_output.o: src/save_output.s
	@echo Assembling save_output...
	@as $(AS_FLAGS) $(DEBUG) src/save_output.s -o obj/save_output.o

obj/somma_funz.o: src/somma_funz.s
	@echo Assembling somma_funz...
	@as $(AS_FLAGS) $(DEBUG) src/somma_funz.s -o obj/somma_funz.o 

obj/sottrazione_funz.o: src/sottrazione_funz.s
	@echo Assembling sottrazione_funz...
	@as $(AS_FLAGS) $(DEBUG) src/sottrazione_funz.s -o obj/sottrazione_funz.o

obj/moltiplicazione_funz.o: src/moltiplicazione_funz.s
	@echo Assembling moltiplicazione_funz...
	@as $(AS_FLAGS) $(DEBUG) src/moltiplicazione_funz.s -o obj/moltiplicazione_funz.o



.PHONY: clean

clean:
	@echo Cleaning obj/ bin/ ...
	@rm -rf obj/*
	@rm -rf bin/*
	@echo Done!



