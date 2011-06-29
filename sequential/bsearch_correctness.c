#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "bsearch_lib.h"

int main(int argc, char *argv[])
{

	if (argc < 4) {
		fprintf(stderr, "usages:\t%s <D size > <Q size> <I/T size> "
				"<seed>\n", argv[0]);
		return 1;
	}
	int D_size = atoi(argv[1]); // size of data set D
	int Q_size = atoi(argv[2]); // size of query set Q
	int I_size = atoi(argv[3]);
	int T_size = I_size;
	int seed = atoi(argv[4]);

	srand(seed);

	int *D = (int *) malloc(D_size * sizeof(int));

	int j;
	for (j = 0; j < D_size; j++)
		D[j] = rand();

	qsort(D, D_size, sizeof(int), compare_int);

	int *I = (int *) malloc(I_size * sizeof(int));

	for (j = 0; j < I_size; j++) 
		I[ j ] = D[ i_to_I(j,I_size,D_size) ];

	int *T = (int *) malloc(T_size * sizeof(int));

	for (j = 0; j < T_size; j++) 
		T[ j ] = D[ i_to_T(j,T_size,D_size) ];



	/* PRINT LIST
	for (j = 0; j < d; j++)
		printf("%d\t%d\n", j, D[j]);
	*/

	int *BR = (int *) malloc(Q_size * sizeof(int));
	int *IR = (int *) malloc(Q_size * sizeof(int));
	int *TR = (int *) malloc(Q_size * sizeof(int));
	/* Search list */
	unsigned long total_time = 0;
	for (j = 0; j < Q_size; j++) {
		int r = rand();

		BR[j] = b_search(r, D, D_size, -1, D_size);
		IR[j] = i_b_search(r, D, D_size, I, I_size);
		TR[j] = t_b_search(r, D, D_size, T, T_size);
	}

	for (j = 0; j < Q_size; j++)
		printf("%d\tb:%d\ti:%d\tt:%d\n", j, BR[j], IR[j], TR[j]);
	/*
		if ( (BR[j] != IR[j]) ||
			 (BR[j] != TR[j]) )
			printf("%d\tb:%d\ti:%d\tt:%d\n", j, BR[j], IR[j], TR[j]);
	*/



	return 0;
}
