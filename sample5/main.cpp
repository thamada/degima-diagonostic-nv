#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

#include "get_time.h"

namespace GPUfunc{	void initialize();	void run();	void finalize();}

int main( int argc, char** argv)
{
	GPUfunc::initialize();
	double t0 = get_time(); 

	for(int i=0; i<5; i++){
		GPUfunc::run();
		printf("t: %.16f sec\n", get_time() - t0);
	}

	GPUfunc::finalize();
}


