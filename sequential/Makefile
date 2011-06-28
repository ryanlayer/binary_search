CFLAGS=-g

i_bsearch: i_bsearch.o timer.o bsearch_lib.o
	gcc -o i_bsearch i_bsearch.o timer.o bsearch_lib.o -lm

t_bsearch: t_bsearch.o timer.o bsearch_lib.o
	gcc $(CFLAGS) -o t_bsearch t_bsearch.o timer.o bsearch_lib.o -lm

bsearch: bsearch.o timer.o bsearch_lib.o
	gcc -o bsearch bsearch.o timer.o bsearch_lib.o -lm

clean:
	rm -f $(EXECS) *.a *.o $(LIBS) $(OBJS)

