CC = gcc
CFLAGS = -w -O3
MAIN = fmm

.PHONY: all clean

all: $(MAIN)

$(MAIN): main.o fmm.o utilities.o
	$(CC) $(CFLAGS) $^ -o $@

main.o: main.c fmm.h
	$(CC) $(CFLAGS) -c main.c

fmm.o: fmm.c fmm.h
	$(CC) $(CFLAGS) -c fmm.c

utilities.o: utilities.c fmm.h
	$(CC) $(CFLAGS) -c utilities.c

clean:
	rm -f *.o $(MAIN)
