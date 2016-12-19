CC = g++
TARGET = test
EXE = run.exe

#NLOOP = 10
NLOOP =  10240 # 3 min
#NLOOP =  51200 # 15 min
#NLOOP = 204800 # 1 hour

all: cu2obj
	$(CC) $(TARGET).o -o $(EXE) -L$(CUDA_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/lib -lcuda -lcudart -lGL -lGLU  -lcutil_x86_64

cu2obj: 
	nvcc -c $(TARGET).cu -o $(TARGET).o \
       -I$(SDK_INSTALL_PATH)/common/inc -I$(CUDA_INSTALL_PATH)/include -I. \
       -Xcompiler '-Wall' \
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


clean:
	rm -rf *.o *~ .*~ $(EXE)

#--gpu-architecture 'sm_10'

test: chk0 chk1 chk2 chk3

chk0:
	m.do '/export/opt/src/sample/sample-cuda/hwtest/run.exe 0 $(NLOOP)' ./hosts| sort >> ~/HWTEST.LOG

chk1:
	m.do '/export/opt/src/sample/sample-cuda/hwtest/run.exe 1 $(NLOOP)' ./hosts| sort >> ~/HWTEST.LOG

chk2:
	m.do '/export/opt/src/sample/sample-cuda/hwtest/run.exe 2 $(NLOOP)' ./hosts| sort >> ~/HWTEST.LOG

chk3:
	m.do '/export/opt/src/sample/sample-cuda/hwtest/run.exe 3 $(NLOOP)' ./hosts| sort >> ~/HWTEST.LOG

short:
	./node_test.pl 0 &
	./node_test.pl 1 &
	./node_test.pl 2 &
	./node_test.pl 3 &

gg:
	grep -v SU log/HWTEST.LOG.g* |sort - 

long: # @g134 de run !
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 0' ./hosts &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 1' ./hosts &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 2' ./hosts &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 3' ./hosts

full:
	m.do /export/opt/src/sample/sample-cuda/hwtest/node_test_allgpu.pl ./hosts

tiny:
	./run.exe 0 1;
	./run.exe 1 1;
	./run.exe 2 1;
	./run.exe 3 1;


g36: # @g36
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 0' ./list/hosts.001-039 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 1' ./list/hosts.001-039 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 2' ./list/hosts.001-039 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 3' ./list/hosts.001-039

g64: # @g64
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 0' ./list/hosts.040-079 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 1' ./list/hosts.040-079 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 2' ./list/hosts.040-079 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 3' ./list/hosts.040-079

g71: # @g71
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 0' ./list/hosts.080-117 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 1' ./list/hosts.080-117 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 2' ./list/hosts.080-117 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 3' ./list/hosts.080-117

g133: # @g133
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 0' ./list/hosts.118-167 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 1' ./list/hosts.118-167 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 2' ./list/hosts.118-167 &
	m.do '/export/opt/src/sample/sample-cuda/hwtest/node_test.pl 3' ./list/hosts.118-167

# g36, g64, g71, g133

