MPICC = mpicxx
EXE = run.exe

all: run.exe

run.exe: get_time.o GPUfunc.o main.o
	$(MPICC) main.o GPUfunc.o get_time.o \
	-o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

main.o: main.cpp
	$(MPICC) -c main.cpp


GPUfunc.o : GPUfunc.cu
	nvcc -arch=sm_30 --maxrregcount 10 --ptxas-options=-v -c GPUfunc.cu -o GPUfunc.o 

cubin : 
	nvcc --cubin -arch=sm_30 --maxrregcount 10 --ptxas-options=-v GPUfunc.cu 

clean:
	rm -rf *.o *~ .*~ $(EXE)

check:
	deviceQuery


run:
	mpirun -n 8 ./run.exe

