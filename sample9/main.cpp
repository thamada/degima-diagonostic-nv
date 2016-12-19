#include <mpi.h>
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>

#include "get_time.h"
#include "initGPU.h"

int main( int argc, char** argv)
{
  MPI_Init(&argc, &argv);
  int proc_id, n_proc;
  MPI_Comm_rank(MPI_COMM_WORLD, &proc_id);
  MPI_Comm_size(MPI_COMM_WORLD, &n_proc);
	assert(n_proc >= 0);
	if(0 == proc_id) printf("Number of Processors = %d\n", n_proc);
	MPI_Barrier(MPI_COMM_WORLD);

	printf("[%d]\n", proc_id);
	double t0 = get_time();

	//---------------------------
	int devid = initGPU(proc_id);
	//---------------------------

	printf("[%d] using GPU[%d]", proc_id, devid);
	std::cout << std::endl;
	double t1 = get_time();

	//	MPI_Barrier(MPI_COMM_WORLD);

	printf("[%d] -------------- %.16f sec", proc_id, t1- t0);
	std::cout << std::endl;

  MPI_Finalize();
	return 0;
}
