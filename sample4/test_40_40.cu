#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

namespace myNamespace_40_40{
	static double* hmem_i;
	static double* hmem_o;
	static double* dmem_i;
	static double* dmem_o;
	static cudaStream_t stream;
	static int nb    = 1;   //1024*1024*64*2; // max 1024*1024*64*2
	static int nthre = 1; // max 65535
	static int nthre_total = nb*nthre;
	static int nword =  1024;
	static int mem_size = sizeof(double) * nword;
	static int mem_size_o = nthre_total*sizeof(double);

	__device__ double myDeviceFunc(double* in, int nword)
	{
		double z=0.0;

		for(int i=0; i<nword; i++)
			z += in[i];

		return (z);
	} 

	__global__ void kernel(double* in, double* out, int nword)
	{
		int tid = threadIdx.x;
		int bid = blockIdx.x;
		int index = blockDim.x*bid + tid;
		double z = myDeviceFunc(in, nword);
		out[index] = z;
	}

	void initialize()
	{
		static bool is_first = true;
		if(false == is_first) return;

		// setup stream
		cudaStreamCreate(&stream);
		// input buffer (Host)
		hmem_i = (double*) malloc(mem_size);
		for(int i=0; i<nword; i++) hmem_i[i] = (double)i;
		// input buffer (GPU)
		cudaMalloc( (void**) &dmem_i, mem_size);
		cudaMemcpyAsync(dmem_i, hmem_i, mem_size, cudaMemcpyHostToDevice, stream);
		// output buffer (Host/GPU)
		cudaMalloc( (void**) &dmem_o, mem_size_o);
		hmem_o = (double*) malloc(mem_size_o);

		printf("stream #: %d\n", stream);
		printf("# threads:   %d \n", nthre_total);
		printf("mem_size:    %d MB\n", mem_size >> 20);
		printf("mem_size_o:    %d kB\n", mem_size_o >> 10);
		is_first = false;
	}

	void run(int n_run)
	{
		kernel<<< nb, nthre, 0, stream >>>(dmem_i, dmem_o, nword);
		cudaMemcpyAsync(hmem_o, dmem_o, mem_size_o, cudaMemcpyDeviceToHost, stream);

		/*
		for(int i=0; i<nthre_total; i++){
			double z = hmem_o[i];
			if(i>(nthre_total-4)) printf("%d, %f\n", i, z);
		}
		*/

		printf("%d: %d, %f\n", stream, nthre_total-1, hmem_o[nthre_total-1]);

		//		if(n_run % 32 == 31) cudaStreamSynchronize(stream);

		return;
	}

	void finalize(){
		free(hmem_i);
		free(hmem_o);
		cudaFree(dmem_i);
		cudaFree(dmem_o);
		cudaStreamSynchronize(stream);
		cudaStreamDestroy(stream);
	}
}

