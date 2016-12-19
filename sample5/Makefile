CC = g++
EXE = run.exe

all: run.exe

run.exe: get_time.o GPUfunc.o main.o
	$(CC) main.o GPUfunc.o get_time.o \
	-o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

get_time.o : get_time.cpp
	g++ -c get_time.cpp

GPUfunc.o : GPUfunc.cu
	nvcc -arch=sm_30 --maxrregcount 10 --ptxas-options=-v -c GPUfunc.cu -o GPUfunc.o 

cubin : 
	nvcc --cubin -arch=sm_30 --maxrregcount 10 --ptxas-options=-v GPUfunc.cu 


main.o: main.cpp
	$(CC) -c main.cpp -o main.o

clean:
	rm -rf *.o *~ .*~ $(EXE)

check:
	deviceQuery
