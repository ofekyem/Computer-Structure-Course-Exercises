CC = gcc
CFLAGS = -Wall -Wextra -std=c99

all: cache

cache: cache.o
	$(CC) $(CFLAGS) -o cache cache.o

cache.o: cache.c
	$(CC) $(CFLAGS) -c cache.c

clean:
	rm -f cache cache.o

