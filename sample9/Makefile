EXE = run.exe

MPICC = $(shell which mpicxx)
ifeq ($(MPICC),)
      $(error MPI not found.)
endif

all: run.exe

$(EXE): main.o get_time.o initGPU.o
	$(MPICC) $^ -o $@ \
	 -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

main.o: main.cpp
	$(MPICC) -c main.cpp

initGPU.o: initGPU.cu
	nvcc -arch=sm_30 -c initGPU.cu

clean:
	rm -rf *.o *~ .*~ $(EXE)

check:
	deviceQuery


run:
	mpirun -n 8 ./run.exe

