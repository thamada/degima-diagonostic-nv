#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

void calc_on_cpu(float* vec_X, float* vec_Y, float* vec_Z, int nword)
{
	for(int i=0; i<nword; i++){
		vec_Z[i] = vec_X[i] + vec_Y[i];
	}
}


__global__ void kernel(float* vec_X, float* vec_Y, float* vec_Z, int nword)
{
  int tid = threadIdx.x;
  int bid = blockIdx.x;
	int i = blockDim.x*bid + tid;
	vec_Z[i] = vec_X[i] + vec_Y[i];
}

int main( int argc, char** argv) 
{
	int nb    = 512; // max 65535
	int nthre = 128; // max 512

	int nword = nb * nthre;
	int mem_size = sizeof(float) * nword;
	printf("# threads:   %d \n", nb*nthre);
	printf("mem_size:    %d Kbyte\n", mem_size >> 10);

	float* hval_X = (float*) malloc(mem_size);
	float* hval_Y = (float*) malloc(mem_size);
	float* hval_Z = (float*) malloc(mem_size);
	float* dval_X;
	float* dval_Y;
	float* dval_Z;
	cudaMalloc( (void**) &dval_X, mem_size);
	cudaMalloc( (void**) &dval_Y, mem_size);
	cudaMalloc( (void**) &dval_Z, mem_size);

	for(int i=0; i<nword; i++){
		float a = (float) i;
		hval_X[i] =  a;
		hval_Y[i] = -a;
	}

	cudaMemcpy(dval_X, hval_X, mem_size, cudaMemcpyHostToDevice);
	cudaMemcpy(dval_Y, hval_Y, mem_size, cudaMemcpyHostToDevice);

	dim3  grid(nb);
	dim3  threads(nthre);
	kernel<<< grid, threads >>>(dval_X, dval_Y, dval_Z, nword);
	cudaMemcpy(hval_Z, dval_Z, mem_size, cudaMemcpyDeviceToHost);

	//		calc_on_cpu(hval_X, hval_Y, hval_Z, nword);

	for(int i=0; i<nword; i++){
		printf("%d: %f + %f => %f\n", i, hval_X[i], hval_Y[i], hval_Z[i]);
	}

	free(hval_X);
	free(hval_Y);
	free(hval_Z);
	cudaFree(dval_X);
	cudaFree(dval_Y);
	cudaFree(dval_Z);
	return (0);
}
