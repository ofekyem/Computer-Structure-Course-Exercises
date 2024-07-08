#ifndef PSTRING_H
#define PSTRING_H

typedef struct {
	unsigned char len;
	char str[255];
} Pstring;

char pstrlen(Pstring* pstr);

Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j);

Pstring* swapCase(Pstring* pstr);

#endif
