#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "b_search_lib.h"

//{{{ __global__ void binary_search_n( unsigned int *db,
__global__
void b_search( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R )
				     
{
	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	if ( id < size_q )
		R[id] = binary_search_cuda(db, size_db, q[id] );
}
//}}}

//{{{ __global__ void gen_index( unsigned int *db,
__global__
void gen_index( unsigned int *db,
			    int size_db, 
				unsigned int *I,
				int size_I)
				     
{
	//extern __shared__ unsigned int I[];

	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	int i;
	if ( id < size_I) {
		i = i_to_I(id, size_I, size_db);
		I[id] = db[i];
	}
}
//}}}

//{{{ __global__ void gen_tree( unsigned int *db,
__global__
void gen_tree( unsigned int *db,
			    int size_db, 
				unsigned int *T,
				int size_T)
				     
{
	//extern __shared__ unsigned int I[];

	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	int i;
	if ( id < size_T) {
		i = i_to_T(id, size_T, size_db);
		T[id] = db[i];
	}
}
//}}}

//{{{int i_to_T(int i, int T_size, int D_size)
__device__
unsigned int i_to_T(int i, int T_size, int D_size)
{
	int hi = D_size;
	double row_d = logf(i + 1) / logf(2);
	unsigned int row = (int) (row_d);
	unsigned int prev = powf(2, row) - 1;
	unsigned int i_row = i - prev;

	unsigned int hi_v = 2*i_row + 1;
	unsigned int lo_v = powf(2, row + 1) - (2*i_row +1);
	unsigned int div = powf(2,row + 1);
	unsigned int r = ( hi_v*hi - lo_v) / div;

	//printf("hi:%d\tlo:%d\trow:%u\thi_v:%u\tlo_v:%u\tdiv:%u\tr:%u\n",
			//hi, lo, row, hi_v, lo_v, div, r);
	return r; 
}       
//}}}       

//{{{int i_to_I(int i, int I_size, int D_size)
unsigned int i_to_I(int i, int I_size, int D_size)
{
	unsigned int regions = I_size + 1;
	unsigned int hi = D_size;
	unsigned int r =( (i+1)*hi - (regions - (i+1))) / (regions);
	return r;
}
//}}}

//{{{ __global__ void i_sm_binary_search( unsigned int *db,
__global__
void i_sm_binary_search( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R,
					 unsigned int *I,
					 int size_I)
				     
{
	extern __shared__ unsigned int L[];

	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	int c, round = 0;

	while ( ( (blockDim.x * round) + threadIdx.x ) < size_I) {
		c = (blockDim.x*round) + threadIdx.x;
		L[c] = I[c];
		++round;
	}
	__syncthreads();

	if (id < size_q) {
		int key = q[id];
		int b = binary_search_cuda(L, size_I, key);

		int new_hi = ( (b+1)*size_db - (size_I - (b+2))) / size_I;
		int new_lo = ( (b  )*size_db - (size_I - (b+1))) / size_I;

		if (b == 0)
			new_lo = -1;
		else if (b == size_I) {
			new_hi = size_db;
			//new_lo = ( (b-1)*size_db + (I_size - (b+1))*lo ) / I_size;
			new_lo = ( (b-1)*size_db - (size_I - (b)) ) / size_I;
		}

		R[id] =  bound_binary_search(db, size_db, key, new_lo, new_hi);
	}
}
//}}}

//{{{ __global__ void i_gm_binary_search( unsigned int *db,
__global__
void i_gm_binary_search( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R,
					 unsigned int *I,
					 int size_I)
				     
{
	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;

	if (id < size_q) {
		int key = q[id];
		int b = binary_search_cuda(I, size_I, key);

		int new_hi = ( (b+1)*size_db - (size_I - (b+2))) / size_I;
		int new_lo = ( (b  )*size_db - (size_I - (b+1))) / size_I;

		if (b == 0)
			new_lo = -1;
		else if (b == size_I) {
			new_hi = size_db;
			new_lo = ( (b-1)*size_db - (size_I - (b)) ) / size_I;
		}

		R[id] =  bound_binary_search(db, size_db, key, new_lo, new_hi);
	}
}
//}}}

//{{{ __global__ void t_sm_binary_search( unsigned int *db,
__global__
void t_sm_binary_search( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R,
					 unsigned int *T,
					 int size_T)
				     
{
	extern __shared__ unsigned int L[];

	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	int c, round = 0;

	while ( ( (blockDim.x * round) + threadIdx.x ) < size_T) {
		c = (blockDim.x*round) + threadIdx.x;
		L[c] = T[c];
		++round;
	}
	__syncthreads();


	if (id < size_q) {
		int key = q[id];

		unsigned int b = 0;
		unsigned int t = 0;

		while (b < size_T) {
			t = L[b];
			if (key < t)
				b = 2*(b) + 1;
			else if (key > t)
				b = 2*(b) + 2;
			else
				break;
		}

		if (t == key)
			R[id] = b;
		else {
			int new_hi, new_lo;
			region_to_hi_lo(b - size_T, size_T + 1, size_db, &new_hi, &new_lo);
			unsigned int x =  bound_binary_search(
					db, size_db, key, new_lo, new_hi);
			R[id] = x;
		}
	}
}
//}}}

//{{{ __global__ void t_gm_binary_search( unsigned int *db,
__global__
void t_gm_binary_search( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R,
					 unsigned int *T,
					 int size_T)
				     
{
	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	if (id < size_q) {
		int key = q[id];

		unsigned int b = 0;
		unsigned int t = 0;

		while (b < size_T) {
			t = T[b];
			if (key < t)
				b = 2*(b) + 1;
			else if (key > t)
				b = 2*(b) + 2;
			else
				break;
		}

		if (t == key)
			R[id] = b;
		else {
			int new_hi, new_lo;
			region_to_hi_lo(b - size_T, size_T + 1, size_db, &new_hi, &new_lo);
			unsigned int x =  bound_binary_search(
					db, size_db, key, new_lo, new_hi);
			R[id] = x;
		}
	}
}
//}}}

//{{{ __global__ void binary_search_i( unsigned int *db,
__global__
void binary_search_i( unsigned int *db,
					 int size_db, 
					 unsigned int *q,
					 int size_q, 
					 unsigned int *R,
					 int size_I)
				     
{
	extern __shared__ unsigned int I[];

	unsigned int id = (blockIdx.x * blockDim.x) + threadIdx.x;
	int i, c, round = 0;

	while ( ( (blockDim.x * round) + threadIdx.x ) < size_I) {
		c = (blockDim.x*round) + threadIdx.x;
		i = ((c + 1)*size_db - (size_I - c + 1))/size_I;
		I[c] = db[i];
		++round;
		//if ( blockIdx.x == 0 )
			//R[c] = I[c];
	}
	__syncthreads();

	if (id < size_q) {
		int key = q[id];
		int b = binary_search_cuda(I, size_I, key);

		int new_hi = ( (b+1)*size_db - (size_I - (b+2))) / size_I;
		int new_lo = ( (b  )*size_db - (size_I - (b+1))) / size_I;

		if (b == 0)
			new_lo = -1;
		else if (b == size_I) {
			new_hi = size_db;
			//new_lo = ( (b-1)*size_db + (I_size - (b+1))*lo ) / I_size;
			new_lo = ( (b-1)*size_db - (size_I - (b)) ) / size_I;
		}

		R[id] =  bound_binary_search(db, size_db, key, new_lo, new_hi);
		//R[id] =  id;
	}
}
//}}}

//{{{ __device__ int bound_binary_search( unsigned int *db,
__device__
int bound_binary_search( unsigned int *db,
				   int size_db, 
				   unsigned int s,
				   int lo,
				   int hi) 
{
	int mid;
	while ( hi - lo > 1) {
		mid = (hi + lo) / 2;

		if ( db[mid] < s )
			lo = mid;
		else
			hi = mid;
	}
	return hi;
}
//}}}

//{{{ __device__ int binary_search_cuda( unsigned int *db, int size_db, unsigned int
__device__
int binary_search_cuda( unsigned int *db,
				   int size_db, 
				   unsigned int s) 
{
	int lo = -1, hi = size_db, mid;
	while ( hi - lo > 1) {
		mid = (hi + lo) / 2;

		if ( db[mid] < s )
			lo = mid;
		else
			hi = mid;
	}
	return hi;
}
//}}}

//{{{ __device__ void region_to_hi_lo(int region, int I_size, int D_size, int
__device__
void region_to_hi_lo(int region, int I_size, int D_size, int *D_hi, int *D_lo)
{
	unsigned int hi = D_size;
	int new_hi = ( (region+1)*hi - (I_size - (region+1)) ) / I_size;
	int new_lo = (( (region)*hi - (I_size - (region+1)) ) / I_size) - 1;

	if (region == 0)
		new_lo = -1;
	else if (region == I_size) {
		new_hi = D_size;
		new_lo = ( (region-1)*hi - (I_size - (region+1)) ) / I_size;
	}
	
	*D_hi = new_hi;
	*D_lo = new_lo;
}
//}}}
