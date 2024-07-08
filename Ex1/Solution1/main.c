#include <stdio.h>
#include "pstring.h"

#define arraySize(x) (sizeof(x) / sizeof(x[0]))

extern void run_func(int choice, Pstring *pstr1, Pstring *pstr2);

void get_pstring(Pstring *pstr) {
	/* Get pstring length */
	printf("Enter Pstring length: ");
	scanf("%hhu", &pstr->len);

	/* Flush stdin buffer */
	int c;
	while ((c = getchar()) != '\n' && c != EOF);
	
	/* Get pstring */
	printf("Enter Pstring: ");
	fgets(pstr->str, pstr->len + 1, stdin);

	/* Remove trailing newline */
	pstr->str[pstr->len] = '\0';
}

int main(void) {
	/* Prompt user for two Pstrings */
	Pstring pstr1, pstr2;
	get_pstring(&pstr1);
	get_pstring(&pstr2);

	/* Print menu for user */
	char *descriptions[] = {
		"31. pstrlen",
		"33. swapCase",
		"34. pstrijcpy",
	};

	puts("Choose a function: ");

	for (int i = 0; i < arraySize(descriptions); i++) {
		printf("\t%s\n", descriptions[i]);
	}

	/* Get user choice, and call func_select */
	int choice;
	scanf("%d", &choice);
	run_func(choice, &pstr1, &pstr2);
	
	return 0;
}
