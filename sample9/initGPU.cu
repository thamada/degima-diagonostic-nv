#include <iostream>
#include <string.h>
#include <stdio.h>
#include <assert.h>
using namespace std;

extern "C"
int initGPU(int mpi_proc_id)
{
	cudaError_t err;

	// total number of GPUs
	int n_gpu;
	err = cudaGetDeviceCount(&n_gpu);
	assert(err == cudaSuccess);
	assert(n_gpu > 0);

	// select a GPU
	int devid = mpi_proc_id % n_gpu;
	err = cudaSetDevice(devid);
	assert(err == cudaSuccess);

	// check device Id
	int devid2 = -1;
	err = cudaGetDevice(&devid2);
	assert(err == cudaSuccess);
	assert(devid == devid2);	

	return (devid);
}
