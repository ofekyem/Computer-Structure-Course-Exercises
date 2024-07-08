// Ofek Yemini 

typedef unsigned char uchar;
#include <stdio.h>
#include <stdlib.h>

typedef struct cache_line_s {
    uchar valid;
    uchar frequency;
    long int tag;
    uchar* block;
} cache_line_t;

typedef struct cache_s {
    uchar s;
    uchar t;
    uchar b;
    uchar E;
    cache_line_t** cache;
} cache_t;


cache_t initialize_cache(uchar s, uchar t, uchar b, uchar E){
    //initializing the cache and set the inputs into struct fields
    cache_t cache;
    cache.s = s;
    cache.t = t;
    cache.b = b;
    cache.E = E;
    // lets allocate dynamic place and set fields of cache line to 0
    cache.cache = (cache_line_t**)malloc((1 << s) * sizeof(cache_line_t*));
    for (int i = 0; i < (1 << s); i++){
        cache.cache[i] = (cache_line_t*)malloc(E * sizeof(cache_line_t));
        for (int j = 0; j < E; j++){
            cache.cache[i][j].valid = 0;
            cache.cache[i][j].frequency = 0;
            cache.cache[i][j].tag = 0;
            cache.cache[i][j].block = (uchar*)malloc((1 << b) * sizeof(uchar));
        }
    }
    return cache;
}

uchar read_byte(cache_t cache, uchar* start, long int off) {

    int B = 1 << cache.b; // the number of bytes per block
    int E = cache.E; // the number of lines per set

    // now lets set tag, index and block offset
    long int tag = off >> (cache.s + cache.b); 
    int set = (off >> cache.b) & ((1 << cache.s) - 1);
    int block = off & ((1 << cache.b) - 1);
    int block2 = off & ~((1 << cache.b) - 1); 

    // lets search in cache for the byte, if it finds it, add its frequency and return it
    int minIndex = -1;
    int invalidIndex = -1;
    for (int i = 0; i < E; i++) {
        if (cache.cache[set][i].valid == 1 && cache.cache[set][i].tag == tag) {
            cache.cache[set][i].frequency++;
            return cache.cache[set][i].block[block];
        }
        if (cache.cache[set][i].valid == 0 && invalidIndex == -1) {
            invalidIndex = i;
        }
        if ((cache.cache[set][i].frequency < cache.cache[set][minIndex].frequency || minIndex == -1) && cache.cache[set][i].valid == 1) {
            minIndex = i;
        }
    }

    // if it hasn't been found in the cache, then load it into cache
    int indexToUse = (invalidIndex != -1) ? invalidIndex : minIndex;
    // now lets write the byte into the cache and return
    cache.cache[set][indexToUse].valid = 1;
    cache.cache[set][indexToUse].frequency = 1;
    cache.cache[set][indexToUse].tag = tag;
    for (int j = 0; j < B; j++) {
        cache.cache[set][indexToUse].block[j] = start[block2 + j];
    }

    return cache.cache[set][indexToUse].block[block];
}


void write_byte(cache_t cache, uchar* start, long int off, uchar new) {
    int B = 1 << cache.b; // the number of bytes per block
    int E = cache.E; // the number of lines per set

    // now lets set tag, index and block offset
    long int tag = off >> (cache.s + cache.b); 
    int set = (off >> cache.b) & ((1 << cache.s) - 1);
    int block = off & ((1 << cache.b) - 1);
    int block2 = off & ~((1 << cache.b) - 1); 

    // lets search in cache for the byte, if it finds it, add its frequency and return it
    int minIndex = -1;
    int invalidIndex = -1;
    for (int i = 0; i < E; i++) {
        if (cache.cache[set][i].valid == 1 && cache.cache[set][i].tag == tag) {
            cache.cache[set][i].frequency++;
            cache.cache[set][i].block[block] = new;
            // Update the corresponding byte in memory
            start[off] = new;
            return;
        }
        if (cache.cache[set][i].valid == 0 && invalidIndex == -1) {
            invalidIndex = i;
        }
        if ((cache.cache[set][i].frequency < cache.cache[set][minIndex].frequency || minIndex == -1) && cache.cache[set][i].valid == 1) {
            minIndex = i;
        }
    }

    // if it hasn't been found in the cache, then load it into cache
    int indexToUse = (invalidIndex != -1) ? invalidIndex : minIndex;
    // now lets write the byte into the cache and return
    cache.cache[set][indexToUse].valid = 1;
    cache.cache[set][indexToUse].frequency = 1;
    cache.cache[set][indexToUse].tag = tag;
    for (int j = 0; j < B; j++) {
        cache.cache[set][indexToUse].block[j] = start[block2 + j];
    }
    // lets update the coresponding byte in memory
    start[off] = new;
}



void print_cache(cache_t cache)
{
    int S = 1 << cache.s;
    int B = 1 << cache.b;

    for (int i = 0; i < S; i++)
    {
        printf("Set %d\n", i);
        for (int j = 0; j < cache.E; j++)
        {
            printf("%1d %d 0x%0*lx ", cache.cache[i][j].valid,
                   cache.cache[i][j].frequency, cache.t, cache.cache[i][j].tag);
            for (int k = 0; k < B; k++)
            {
                printf("%02x ", cache.cache[i][j].block[k]);
            }
            puts("");
        }
    }
}

int main()
{
    int n;
    printf("Size of data: ");
    scanf("%d", &n);
    uchar *mem = malloc(n);
    printf("Input data >> ");
    for (int i = 0; i < n; i++)
        scanf("%hhd", mem + i);
    int s, t, b, E;
    printf("s t b E: ");
    scanf("%d %d %d %d", &s, &t, &b, &E);
    cache_t cache = initialize_cache(s, t, b, E);
    while (1)
    {
        scanf("%d", &n);
        if (n < 0)
            break;
        read_byte(cache, mem, n);
    }
    puts("");
    print_cache(cache);
    free(mem);
}