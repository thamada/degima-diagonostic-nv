#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

namespace GPUfunc{
	static int nb    = 64; //1024*1024*64*2; // max 1024*1024*64*2
	static int nthre = 1; // max 65535
	static int nthre_total = nb*nthre;
	static int nword =  1024*1024*8;
	static int mem_size = sizeof(double) * nword;
	static int mem_size_o = nthre_total*sizeof(double);
	static double* hmem_i;
	static double* hmem_o;
	static double* dmem_i;
	static double* dmem_o;

#define NLOOP (1000)
#define NX (14705)

	__device__ double myDeviceFunc_0(double* in, int nword)
	{
		double z=0.0;
		double x[NX];
		for(int i=0; i<NX; i++)  x[i] = 1.0;
		for(int j=0; j<NLOOP; j++)	for(int i=0; i<NX; i++)  z += x[i];
		return (z);
	} 

	__device__ double myDeviceFunc_1(double* in, int nword)
	{
		double z=0.0;
		double x[NX];
		for(int i=0; i<NX; i++)  x[i] = 1.0;
		for(int j=0; j<NLOOP; j++)	for(int i=0; i<NX; i++)  z += x[i];
		return (z);
	} 

	__device__ double myDeviceFunc_2(double* in, int nword)
	{
		double z=0.0;
		double x[NX];
		for(int i=0; i<NX; i++)  x[i] = 1.0;
		for(int j=0; j<NLOOP; j++)	for(int i=0; i<NX; i++)  z += x[i];
		return (z);
	} 

	__device__ double myDeviceFunc_3(double* in, int nword)
	{
		double z=0.0;
		double x[NX];
		for(int i=0; i<NX; i++)  x[i] = 1.0;
		for(int j=0; j<NLOOP; j++)	for(int i=0; i<NX; i++)  z += x[i];
		return (z);
	} 

	__global__ void kernel(double* in, double* out, int nword)
	{
		int tid = threadIdx.x;
		int bid = blockIdx.x;
		int global_id = blockDim.x*bid + tid;
		double z;

		int kernel_num = global_id % 4;

		switch(kernel_num){
		case 0: 
			z = myDeviceFunc_0(in, nword);
			break;
		case 1: 
			z = myDeviceFunc_1(in, nword);
			break;
		case 2: 
			z = myDeviceFunc_2(in, nword);
			break;
		case 3: 
			z = myDeviceFunc_3(in, nword);
			break;
		default:
			z = myDeviceFunc_0(in, nword);
		}
		out[global_id] = z;
	}

	void initialize()
	{
		static bool is_first = true;
		if(false == is_first) return;

		// input buffer (Host)
		hmem_i = (double*) malloc(mem_size);
		for(int i=0; i<nword; i++) hmem_i[i] = (double)i;
		// input buffer (GPU)
		cudaMalloc( (void**) &dmem_i, mem_size);
		cudaMemcpy(dmem_i, hmem_i, mem_size, cudaMemcpyHostToDevice);
		// output buffer (Host/GPU)
		cudaMalloc( (void**) &dmem_o, mem_size_o);
		hmem_o = (double*) malloc(mem_size_o);

		printf("# threads:   %d \n", nthre_total);
		printf("mem_size:    %d MB\n", mem_size >> 20);
		printf("mem_size_o:    %d kB\n", mem_size_o >> 10);
		is_first = false;
	}

	void run()
	{
		kernel<<< nb, nthre>>>(dmem_i, dmem_o, nword);
		cudaMemcpy(hmem_o, dmem_o, mem_size_o, cudaMemcpyDeviceToHost);

		/*
		for(int i=0; i<nthre_total; i++){
			double z = hmem_o[i];
			if(i>(nthre_total-4)) printf("%d, %f\n", i, z);
		}
		*/

		printf("%d, %e\n", nthre_total-1, hmem_o[nthre_total-1]);

		return;
	}

	void finalize(){
		free(hmem_i);
		free(hmem_o);
		cudaFree(dmem_i);
		cudaFree(dmem_o);
	}

}

