extern __device__ double myDeviceFunc(double* in, int nword)
{
	double z=0.;
	while(z < 7.777777){
		z += 1.0e-5;
	}
	return ((double)z);
} 
