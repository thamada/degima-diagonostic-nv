CC = g++
TARGET = test
EXE = run.exe

all: cu2obj
	$(CC) $(TARGET).o -o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart 

cu2obj: 
	nvcc -c $(TARGET).cu -o $(TARGET).o 

clean:
	rm -rf *.o *~ .*~ $(EXE)


check:
	deviceQuery
