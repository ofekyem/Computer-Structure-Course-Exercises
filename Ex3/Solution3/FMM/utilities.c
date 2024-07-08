#include "fmm.h"

int* create_matrix(char* file_name, int n) {
    int* mat;

    int fd = open(file_name, O_RDWR | O_CREAT, 0644);
    if (fd == -1) {
        perror("open error");
        exit(1);
    }

    if (ftruncate(fd, n * n * sizeof(int)) == -1) {
        perror("ftruncate error");
        exit(1);
    }

    mat = mmap(NULL, n * n * sizeof(int), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (mat == MAP_FAILED) {
        perror("mmap error");
        exit(1);
    }

    close(fd);
    return mat;
}

int* read_matrix(char* file_name, int n) {
    int* mat;

    int fd = open(file_name, O_RDONLY);
    if (fd == -1) {
        perror("open error");
        exit(1);
    }

    mat = mmap(NULL, n * n * sizeof(int), PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    if (mat == MAP_FAILED) {
        perror("mmap error");
        exit(1);
    }

    close(fd);
    return mat;
}

void free_matrix(int* mat, int n) {
    munmap(mat, n * n * sizeof(int));
}

void print_matrix(int* mat, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", mat[i * n + j]);
        }
        puts("");
    }
}

double measure_time(char* file1, char* file2, char* file_result, int n) {
	struct timeval startTime;
	struct timeval endTime;
	struct rusage ru;

    int* m1 = read_matrix(file1, n);
    int* m2 = read_matrix(file2, n);
    int* result = create_matrix(file_result, n);

	getrusage(RUSAGE_SELF, &ru); // start timer
	startTime = ru.ru_utime;

    fmm(n, m1, m2, result);

    getrusage(RUSAGE_SELF, &ru); // end timer
    endTime = ru.ru_utime;
    double tS = startTime.tv_sec * 1000000.0 + (startTime.tv_usec);
    double tE = endTime.tv_sec * 1000000.0 + (endTime.tv_usec);

    free_matrix(m1, n);
    free_matrix(m2, n);
    free_matrix(result, n);

    return (tE - tS) / 1000.0;
}

