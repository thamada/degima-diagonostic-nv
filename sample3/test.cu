#include <iostream>
#include <stdio.h>
#include <string.h>
#include <cassert>


__global__ void kernel(int* dval, int nword)
{
  int tid = threadIdx.x;
	int3 bid;
	bid.x = blockIdx.x;
	bid.y = blockIdx.y;

	int nthre = blockDim.x;
	int i   = (gridDim.x*bid.y + bid.x)*nthre + tid;

	dval[i] = i;
}

int main( int argc, char** argv) 
{
	int nby   = 6;
	int nbx   = 65535; // max 65535 blocks

	int nthre = 512;   // max 512 threads
	int nword = nbx * nby * nthre;
	int mem_size = sizeof(int) * nword;
	printf("# threads:   %d \n", nword);
	printf("mem_size:    %d Kbyte\n", mem_size >> 10);

	int* hval = (int*) malloc(mem_size);
	int* dval;
	cudaMalloc( (void**) &dval, mem_size);

	dim3  grid(nbx, nby);
	dim3  threads(nthre);
	kernel<<< grid, threads >>>(dval, nword);

	cudaMemcpy(hval, dval, mem_size, cudaMemcpyDeviceToHost);

	for(int i=0; i<nword; i++){
		int z = hval[i];
		if(i != z) printf("%d: %d\n", i, z);
	}

	free(hval);
	cudaFree(dval);
	return (0);
}
