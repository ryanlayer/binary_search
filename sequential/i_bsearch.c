#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "bsearch_lib.h"

int main(int argc, char *argv[])
{

	if (argc < 5) {
		fprintf(stderr, "usages:\t%s <D size > <Q size> <I size> "
				"<seed>\n", argv[0]);
		return 1;
	}
	int D_size = atoi(argv[1]); // size of data set D
	int Q_size = atoi(argv[2]); // size of query set Q
	int I_size = atoi(argv[3]); // size of index I
	int seed = atoi(argv[4]);

	srand(seed);

	int *D = (int *) malloc(D_size * sizeof(int));

	int j;
	for (j = 0; j < D_size; j++)
		D[j] = rand();

	qsort(D, D_size, sizeof(int), compare_int);

	/* PRINT LIST
	for (j = 0; j < d; j++)
		printf("%d\t%d\n", j, D[j]);
	*/

	int *I = (int *) malloc(I_size * sizeof(int));

	for (j = 0; j < I_size; j++) 
		I[ j ] = D[ i_to_I(j,I_size,D_size) ];

	/* PRINT TREE and INDEX
	for (j = 0; j < d; j++)
		printf("%d\ti:%d,%d\tt:%d,%d\n", 
				j,
				I[j],i_to_I(j,i,d),
				T[j],i_to_T(j,i,d)
			  );
	*/

	/* Search list */
	unsigned long total_time = 0;
	for (j = 0; j < Q_size; j++) {
		int r = rand();

		start();
		int c = i_b_search(r, D, D_size, I, I_size);
		stop();
		total_time += report();
	}

	printf("%lu\n", total_time);

	return 0;
}
