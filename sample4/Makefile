CC = g++
EXE = run.exe

all: run.exe

run.exe: test_00_00.o test_00_01.o test_40_40.o main.o
	$(CC) main.o test_00_00.o test_00_01.o test_40_40.o \
	-o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

test_00_00.o : test_00_00.cu
	nvcc -arch=sm_30 --ptxas-options=-v -c test_00_00.cu -o test_00_00.o 

test_00_01.o : test_00_01.cu
	nvcc -arch=sm_30 --ptxas-options=-v -c test_00_01.cu -o test_00_01.o 

test_40_40.o : test_40_40.cu
	nvcc -arch=sm_30 --ptxas-options=-v -c test_40_40.cu -o test_40_40.o 

main.o: main.cpp
	$(CC) -c main.cpp -o main.o

clean:
	rm -rf *.o *~ .*~ $(EXE)


check:
	deviceQuery
