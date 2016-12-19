#include <iostream>
#include <string.h>
#include <stdio.h>
#include <math.h>
using namespace std;

namespace myNamespace_00_00{	void initialize();	void run(int n_run);	void finalize();}
namespace myNamespace_00_01{	void initialize();	void run(int n_run);	void finalize();}
namespace myNamespace_40_40{	void initialize();	void run(int n_run);	void finalize();}


int main( int argc, char** argv)
{
	myNamespace_00_00::initialize();
	myNamespace_00_01::initialize();
	myNamespace_40_40::initialize();

	for(int i=0; i<2; i++){
		myNamespace_00_00::run(i);
		//		myNamespace_00_01::run(i);
		//		myNamespace_40_40::run(i);
	}

	myNamespace_00_00::finalize();
	myNamespace_00_01::finalize();
	myNamespace_40_40::finalize();
}


