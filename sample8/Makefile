CC = g++
EXE = run.exe

all:  main.o
	$(CC) main.o -o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(CUDA_INSTALL_PATH)/lib -lcuda -lcudart 

main.o: main.cu
	nvcc -c main.cu -o main.o --compiler-options '-Wall'

clean:
	rm -rf *.o *~ .*~ $(EXE)


check:
	deviceQuery
