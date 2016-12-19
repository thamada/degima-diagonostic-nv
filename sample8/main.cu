//Time-stamp: <2013-12-04 13:20:59 hamada>
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
//#define NUM (1024*1024*1024/4) // 1GB
//#define NUM ((1024*1024/4)*(1024 + 512)) // 1.5GB
//#define NUM ((1024*1024/4)*(1024*2) -1) // 2GB-1
//#define NUM ((1024*1024/4)*(1024*2) ) // 2GB
//#define NUM ((1024*1024/4)) // 1MB
#define NUM ((1024*1024/4)*(1024*6-100) ) // 6GB-100MB
using namespace std;

__global__ void kernel(int* x, int n)
{
  int tid = threadIdx.x;
  int bid = blockIdx.x;
	int wid = blockDim.x*bid + tid;
	if(wid > 1) return;
	int z = 0;
	for(size_t i = 0; i<n ; i++)		z += x[i];
	x[0] = z;
}

#include <sys/time.h>
#include <sys/resource.h>
extern "C" double get_time(void)
{
  static struct timeval tv;
  static struct timezone tz;
  gettimeofday(&tv, &tz);
  return ((double)(tv.tv_sec  + tv.tv_usec*1.0e-6));
}

void myCudaMalloc(void** val, size_t mem_size)
{
	double t = get_time();
	cudaError_t err = cudaMalloc(val, mem_size);
	assert(cudaSuccess == err);
	cout << "cudaMalloc: " << get_time() - t << endl; 
}

void myCudaMemcpy(void* dst, const void* src, size_t size, enum cudaMemcpyKind kind)
{
	double t = get_time();
	cudaError_t err = cudaMemcpy(dst, src, size, kind);
	assert(cudaSuccess == err);
	cout << "cudaMemcpy: " << get_time() - t << endl; 
}

int main( int argc, char** argv) 
{
	int nb    = 512; // max 65535
	int nthre = 128; // max 512
	size_t nword = NUM;
	size_t mem_size = sizeof(int) * nword;
	printf("# nword:     %zd \n", nword);
	printf("# threads:   %d  \n", nb*nthre);
	printf("mem_size:    %zd Kbyte\n", mem_size >> 10);
	double t=0.;
	cudaError_t err;
	int* hval = (int*) malloc(mem_size);
	int* hval2 = (int*) malloc(mem_size);
	int* dval = NULL;
	cout << "mem_size:        " <<mem_size << endl;
	cout << "(size_t)mem_size:" <<(size_t)mem_size << endl;
	cout << sizeof(size_t) << endl;

	myCudaMalloc((void**)&dval,  mem_size);

	int z = 0;
	for(size_t i=0; i<nword; i++){hval[i]  = 1;  z += hval[i];}

	myCudaMemcpy(dval,  hval,  mem_size, cudaMemcpyHostToDevice);

	t = get_time();
	kernel<<< nb, nthre >>>(dval, nword);
	err = cudaThreadSynchronize();
	assert(cudaSuccess == err);
	cout << "GPU calc:   " << get_time() - t << endl; 

	myCudaMemcpy(hval,  dval,  mem_size, cudaMemcpyDeviceToHost);

	printf("GPU: %d\n", hval[0]);
	printf("HOS: %d\n", z);

	free(hval);
	cudaFree(dval);


	return (0);
}
