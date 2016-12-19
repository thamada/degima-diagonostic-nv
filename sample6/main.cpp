#include <mpi.h>
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

#include "get_time.h"

namespace GPUfunc{	void initialize(int);	void run();	void finalize();}

int main( int argc, char** argv)
{
  MPI_Init(&argc, &argv);
  int proc_id, n_proc;
  MPI_Comm_rank(MPI_COMM_WORLD, &proc_id);
  MPI_Comm_size(MPI_COMM_WORLD, &n_proc);
	//  if(0 == proc_id) printf("Number of Processors = %d\n", n_proc);

	double t0 = get_time(); 
	printf("[%d]\n", proc_id);

	GPUfunc::initialize(proc_id);

	for(int i=0; i<6; i++){
		GPUfunc::run();
		printf("[%d]\t t: %.16f sec\n", proc_id, get_time() - t0);
	}

	GPUfunc::finalize();

	printf("[%d] -------------- %.16f sec\n", proc_id, get_time() - t0);

  MPI_Finalize();
	return 0;
}
