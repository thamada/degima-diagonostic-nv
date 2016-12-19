#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

namespace GPUfunc{
	static int nb    = 1024; //1024*1024*64*2; // max 1024*1024*64*2
	static int nthre = 1; // max 65535
	static int nthre_total = nb*nthre;
	static int nword =  1024*1024*8;
	static int mem_size = sizeof(double) * nword;
	static int mem_size_o = nthre_total*sizeof(double);
	static double* hmem_i;
	static double* hmem_o;
	static double* dmem_i;
	static double* dmem_o;
	static int mpi_proc_id;

#define NLOOP (1000)

	__device__ double myDeviceFunc_0(double* in, int nword)
	{
		double z=0.;
		while(z < 7.777777){
				z += 1.0e-5;
		}
		return ((double)z);
	} 


	__global__ void kernel(double* in, double* out, int nword)
	{
		int tid = threadIdx.x;
		int bid = blockIdx.x;
		int global_id = blockDim.x*bid + tid;
		double z;

		z = myDeviceFunc_0(in, nword);

		out[global_id] = z;
	}

	void initialize(int _mpi_proc_id)
	{
		static bool is_first = true;
		if(false == is_first) return;

		mpi_proc_id = _mpi_proc_id;

		int GPU_N;
		cudaGetDeviceCount(&GPU_N);
		///		if(0 == mpi_proc_id) printf("CUDA-capable device count: %i\n", GPU_N);

		int devid = mpi_proc_id % GPU_N;
		cudaSetDevice(devid); // <--------------------------- Select a GPU
		printf("[%d] using GPU[%d]\n", mpi_proc_id, devid);

		// input buffer (Host)
		hmem_i = (double*) malloc(mem_size);
		for(int i=0; i<nword; i++) hmem_i[i] = (double)i;
		// input buffer (GPU)
		cudaMalloc( (void**) &dmem_i, mem_size);
		cudaMemcpy(dmem_i, hmem_i, mem_size, cudaMemcpyHostToDevice);
		// output buffer (Host/GPU)
		cudaMalloc( (void**) &dmem_o, mem_size_o);
		hmem_o = (double*) malloc(mem_size_o);

		is_first = false;
	}

	void run()
	{
		kernel<<< nb, nthre>>>(dmem_i, dmem_o, nword);
		cudaMemcpy(hmem_o, dmem_o, mem_size_o, cudaMemcpyDeviceToHost);

		//		printf("[%d] %d, %e\n", mpi_proc_id, nthre_total-1, hmem_o[nthre_total-1]);

		return;
	}

	void finalize(){
		free(hmem_i);
		free(hmem_o);
		cudaFree(dmem_i);
		cudaFree(dmem_o);
	}

}

