CC = gcc
CFLAGS = -g 
MAIN = pstrings

.PHONY: all clean

all: pstrings

$(MAIN): main.o func_select.o pstring.o
	$(CC) $(CFLAGS) $^ -o $@ -no-pie

main.o: main.c pstring.h
	$(CC) $(CFLAGS) -c main.c

func_select.o: func_select.s pstring.h
	$(CC) $(CFLAGS) -c func_select.s

pstring.o: pstring.s
	$(CC) $(CFLAGS) -c pstring.s

clean:
	rm -f *.o $(MAIN)