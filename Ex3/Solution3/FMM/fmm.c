// Ofek Yemini
#include "fmm.h"

// Slow fmm :)
/*
 void fmm(int n, int* m1, int* m2, int* result) {
     for (int i = 0; i < n; i++) {
         for (int j = 0; j < n; j++) {
             result[i * n + j] = 0;  // result[i][j] = 0
             for (int k = 0; k < n; k++) 
                 result[i * n + j] += m1[i * n + k] * m2[k * n + j];  // result[i][j] += m1[i][k] * m2[k][j]
         }
     }
 }
 */

void transpose(int n, int* m2) {
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            int temp = m2[i * n + j];
            m2[i * n + j] = m2[j * n + i];
            m2[j * n + i] = temp;
        }
    }
}

void fmm(int n, int* m1, int* m2, int* result) {
    transpose(n, m2);
    
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int sum = 0;

            for (int k = 0; k < n; k += 8) {
                sum += m1[i * n + k] * m2[j * n + k];
                sum += m1[i * n + k + 1] * m2[j * n + k + 1];
                sum += m1[i * n + k + 2] * m2[j * n + k + 2];
                sum += m1[i * n + k + 3] * m2[j * n + k + 3];
                sum += m1[i * n + k + 4] * m2[j * n + k + 4];
                sum += m1[i * n + k + 5] * m2[j * n + k + 5];
                sum += m1[i * n + k + 6] * m2[j * n + k + 6];
                sum += m1[i * n + k + 7] * m2[j * n + k + 7];
            }
            result[i * n + j] = sum;
        }
    }
}
