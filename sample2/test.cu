#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

__global__ void kernel(int* dval, int nword)
{
  int tid = threadIdx.x;
  int bid = blockIdx.x;
	int i = blockDim.x*bid + tid;
	dval[i] = i;
}

int main( int argc, char** argv) 
{
	/*
	int nb    = 65535; // max 65535
	int nthre = 512; // max 512
	*/
	int nb    = 512; // max 65535
	int nthre = 128; // max 512

	int nword = nb * nthre;
	int mem_size = sizeof(int) * nword;
	printf("# threads:   %d \n", nb*nthre);
	printf("mem_size:    %d Kbyte\n", mem_size >> 10);

	int* hval = (int*) malloc(mem_size);
	int* dval;
	cudaMalloc( (void**) &dval, mem_size);

	dim3  grid(nb);
	dim3  threads(nthre);
	kernel<<< grid, threads >>>(dval, nword);

	cudaMemcpy(hval, dval, mem_size, cudaMemcpyDeviceToHost);

	for(int i=0; i<nword; i++){
		int z = hval[i];
		if(i != z){
			printf("%d, %d\n", i, z);
		}
	}

	free(hval);
	cudaFree(dval);
	return (0);
}
