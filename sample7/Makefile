MPICC = mpicxx
EXE = run.exe

all: run.exe

run.exe: main.o get_time.o myDeviceFunc.o GPUfunc.o GPUfunc__.o
	$(MPICC) $^ -o $@ \
  -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

main.o: main.cpp
	$(MPICC) -c main.cpp

myDeviceFunc.o : myDeviceFunc.cu
	nvcc -arch=sm_30 -dc myDeviceFunc.cu -o myDeviceFunc.o 

GPUfunc.o : GPUfunc.cu
	nvcc -arch=sm_30 -dc GPUfunc.cu -o GPUfunc.o 

GPUfunc__.o: GPUfunc.o myDeviceFunc.o
	nvcc -arch=sm_30 --device-link GPUfunc.o myDeviceFunc.o -o GPUfunc__.o


cubin : 
	nvcc --cubin -arch=sm_30 --maxrregcount 10 --ptxas-options=-v GPUfunc.cu 

clean:
	rm -rf *.o *~ .*~ $(EXE)

check:
	deviceQuery


run:
	mpirun -n 8 ./run.exe

