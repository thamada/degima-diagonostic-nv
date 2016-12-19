//Time-stamp: <2011-01-15 08:20:37 hamada>
//#define DEBUG

#include <iostream>
#include <omp.h>
#include <string.h>
#include <cassert>
#include <cutil.h>

//--------------------------------
#include <sys/time.h>
#include <sys/resource.h>

class Time{
	double t;
public:
	Time() {t = 0.0;}
	struct timeval tv;
	struct timezone tz;
	double get_time(void){
		gettimeofday(&tv, &tz);
		t = (double)(tv.tv_sec  + tv.tv_usec*1.0e-6);
		return (t);
	}
};

__global__ void kernel(int* dval, int nword)
{
  int tid = threadIdx.x;
	int3 bid;
	bid.x = blockIdx.x;
	bid.y = blockIdx.y;
	int nthre = blockDim.x;
	int i   = (gridDim.x*bid.y + bid.x)*nthre + tid;
	dval[i] = ~dval[i];
}

#include <ctime>

void setup_vector(int n, int *x0,  int *x1)
{
	//	srand48(0x19740526);
	srand48((long int)time(NULL));
	for(int i=0; i<n; i++){
		x0[i]= (int)(0xFFFFFFFFull & mrand48());
		x1[i]=x0[i];
	}
}

#include <cutil_inline.h>

class GPU{
public :
	GPU () { }

	void open(int gpuid){
		cutilSafeCall( cudaSetDevice(gpuid) );	
	}

	int GetDevice(){
		int x=999;
		cutilSafeCall( cudaGetDevice(&x) );
		return x;
	}

	void runtest( int gpuid, int nloop)
	{
		int nby   = 6;
		int nbx   = 65535; // max 65535 blocks
		int nthre = 512;   // max 512 threads
		int nword = nbx * nby * nthre;
		int mem_size = sizeof(int) * nword;

#if defined(DEBUG)
		printf("# threads:   %d \n", nword);
		printf("mem_size:    %d Kbyte\n", mem_size >> 10);
#endif

		int* hval = (int*) malloc(mem_size);
		int* zval = (int*) malloc(mem_size);
		int* dval;
		cutilSafeCall( cudaMalloc( (void**) &dval, mem_size) );

		setup_vector(nword, hval, zval);

		Time t;
		double tt;
		tt = t.get_time();

		cutilSafeCall( cudaMemcpy(dval, hval, mem_size, cudaMemcpyHostToDevice) );
		dim3  grid(nbx, nby);
		dim3  threads(nthre);
		for(int i=0; i<nloop; i++){
			kernel<<< grid, threads >>>(dval, nword);
			//		cutilSafeCall( cudaThreadSynchronize() );  // no need !
		}
		cutilCheckMsg("Kernel execution failed");


		cutilSafeCall( cudaMemcpy(hval, dval, mem_size, cudaMemcpyDeviceToHost) );
		tt = t.get_time() - tt;

		int nerr=0;
		for(int i=0; i<nword; i++){
			int x = hval[i];
			int z = zval[i];
			if(x != z) {
				nerr++;
#if defined(DEBUG)
				if(nerr<5) printf("%08d(%03d MB): %08x %08x %08x\n", i, i*sizeof(int)/1024/1024, x, z, x^z);
#endif
			}
		}

		if(nerr > 0){
			printf("FAILED[%d]: %d errors, %f\n", gpuid, nerr, tt);
		}else{
			printf("SUCCESS[%d]: %d errors, %f\n", gpuid, nerr, tt);
		}

		cutilSafeCall(cudaFree(dval));
		free(hval);
		free(zval);
	}
};

int main( int argc, char** argv) 
{
	int nloop = 10240;
	GPU gpu[4];
	int tid[4]={-1, -1, -1, -1};

#pragma omp parallel for
	for(int i=0; i<4 ; i++){
		tid[i] = omp_get_thread_num(); // check
		gpu[i].open(i);
		int devid = gpu[i].GetDevice(); // check
		printf("tid %d, devid %d\n", tid[i], devid);
		gpu[i].runtest(i, nloop*2);
	}
}



