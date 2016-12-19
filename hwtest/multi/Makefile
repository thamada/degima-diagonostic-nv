CC = g++
LIB += -lpthread
TARGET = test
EXE = run.exe


all: test.o
	$(CC) $^ -o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart -lGL -lGLU  -lcutil_x86_64 -lgomp



simpleMultiGPU.o: simpleMultiGPU.cpp
	$(CC) -c $< -I$(SDK_INSTALL_PATH)/common/inc -I$(CUDA_INSTALL_PATH)/include -I. -fopenmp 


#simpleMultiGPU_kernel.o : simpleMultiGPU_kernel.cu

#.cu.o:

%.o : %.cu
	nvcc -c $< \
       -I$(SDK_INSTALL_PATH)/common/inc -I$(CUDA_INSTALL_PATH)/include -I. \
       -Xcompiler '-Wall' \
		   -Xcompiler "-fopenmp" \
       -Xcompiler "-O3" 




back.cu2obj: 
	nvcc --host-compilation 'C++' --use_fast_math -O3 \
          -c $(TARGET).cu -o $(TARGET).o \
          -Xcompiler "-O3" \
          -Xcompiler "-msse -msse2 -msse3" \
          -Xcompiler "-ffast-math" \
          -Xcompiler "-funroll-loops" \
          -Xcompiler "-m64" \
          -Xcompiler "-fPIC " \
          -I$(SDK_INSTALL_PATH)/common/inc -I$(CUDA_INSTALL_PATH)/include -I.


.PHONY: clean

clean:
	rm -rf *.o *~ .*~ $(EXE)

#--gpu-architecture 'sm_10'
