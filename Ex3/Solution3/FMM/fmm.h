#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

int* create_matrix(char* file_name, int n);
int* read_matrix(char* file_name, int n);
void free_matrix(int* mat, int n);
double measure_time(char* file1, char* file2, char* file_result, int n);

void fmm(int n, int* m1, int* m2, int* result);

