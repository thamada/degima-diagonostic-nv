#include <iostream>
#include <stdio.h>
#include <string.h>
#include <math.h>
//#include <cutil.h>

// �ǥХ����ؿ�(GPU¦�Ǽ¹Ԥ�������򵭽�)
// �������
// GPU���꤫��ǡ������äƤ��� +1 ����GPU������᤹
// �Ȥ��������Ǥ�
__global__ void function_on_GPU(float* d_idata, float* d_odata, int nword)
{
  int tid = threadIdx.x;
  int bid = blockIdx.x;

  if((tid == 0) && (bid==0)){      // ��ñ�Τ��������GPU���1�ĤΥ���åɤ˸���
    for(int i = 0; i<nword; i++){
      d_odata[i] =  d_idata[i] + 1.0f ;
    }
  }
}


// main�ؿ�.
// ���ʤߤ� __global__���դ��Ƥ��ʤ��ؿ��������̾��C++�����ɤȤ���CPU¦�Ǽ¹Ԥ���ޤ�.
// (�Ĥޤ� __global__�ʴؿ����ʤ����ñ�ʤ�C++�����ɤʤΤ�g++�ǥ���ѥ����ǽ�Ǥ�)

int main( int argc, char** argv) 
{
    int nword = 1024;
    int mem_size = sizeof(float) * nword;

    // �ۥ��ȥ���(CPU¦)����
    float* h_idata = (float*) malloc(mem_size);
    float* h_odata = (float*) malloc(mem_size);
    for(unsigned int i = 0; i < nword; ++i){
      h_idata[i] = (float) i;
    }

    // �ǥХ�������(GPU¦)����
    float* d_idata;
    cudaMalloc((void**) &d_idata, mem_size);
    float* d_odata;
    cudaMalloc( (void**) &d_odata, mem_size);

    // �ǡ���ž��:  �ۥ��ȥ��� -----> �ǥХ�������
    cudaMemcpy( d_idata, h_idata, mem_size, cudaMemcpyHostToDevice );

    //�ǥХ����ؿ�(GPU��Ǽ¹Ԥ����ؿ�)��¹�
    dim3  grid(128);     // �֥�å���( ���Ѥ���SIMD���å׿� )
    dim3  threads(128);  // ����åɿ�( ���Ѥ��륹��åɿ�(SIMD���å�������))
    // grid*thread(= 128*128)����åɤ�����˥ǥХ����ؿ���¹Ԥ��ޤ�.
    function_on_GPU<<< grid, threads >>>(d_idata, d_odata, nword);

    // �ǡ���ž��:  �ǥХ������� -----> �ۥ��ȥ���
    cudaMemcpy(h_odata, d_odata, mem_size, cudaMemcpyDeviceToHost);

    for(int i=0; i<17; i++){
      printf("%f, %f\n", h_idata[i], h_odata[i]);
    }

    // �����ΰ����
    free(h_idata);
    free(h_odata);
    cudaFree(d_idata);
    cudaFree(d_odata);

    return (0);
}


