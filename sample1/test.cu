#include <iostream>
#include <stdio.h>
#include <string.h>
#include <math.h>
//#include <cutil.h>

// デバイス関数(GPU側で実行する処理を記述)
// この例は
// GPUメモリからデータを取ってきて +1 してGPUメモリに戻す
// という処理です
__global__ void function_on_GPU(float* d_idata, float* d_odata, int nword)
{
  int tid = threadIdx.x;
  int bid = blockIdx.x;

  if((tid == 0) && (bid==0)){      // 簡単のため処理はGPU上の1個のスレッドに限定
    for(int i = 0; i<nword; i++){
      d_odata[i] =  d_idata[i] + 1.0f ;
    }
  }
}


// main関数.
// ちなみに __global__が付いていない関数は全て通常のC++コードとしてCPU側で実行されます.
// (つまり __global__な関数がなければ単なるC++コードなのでg++でコンパイル可能です)

int main( int argc, char** argv) 
{
    int nword = 1024;
    int mem_size = sizeof(float) * nword;

    // ホストメモリ(CPU側)設定
    float* h_idata = (float*) malloc(mem_size);
    float* h_odata = (float*) malloc(mem_size);
    for(unsigned int i = 0; i < nword; ++i){
      h_idata[i] = (float) i;
    }

    // デバイスメモリ(GPU側)設定
    float* d_idata;
    cudaMalloc((void**) &d_idata, mem_size);
    float* d_odata;
    cudaMalloc( (void**) &d_odata, mem_size);

    // データ転送:  ホストメモリ -----> デバイスメモリ
    cudaMemcpy( d_idata, h_idata, mem_size, cudaMemcpyHostToDevice );

    //デバイス関数(GPU上で実行される関数)を実行
    dim3  grid(128);     // ブロック数( 使用するSIMDチップ数 )
    dim3  threads(128);  // スレッド数( 使用するスレッド数(SIMDチップ当たり))
    // grid*thread(= 128*128)スレッドが並列にデバイス関数を実行します.
    function_on_GPU<<< grid, threads >>>(d_idata, d_odata, nword);

    // データ転送:  デバイスメモリ -----> ホストメモリ
    cudaMemcpy(h_odata, d_odata, mem_size, cudaMemcpyDeviceToHost);

    for(int i=0; i<17; i++){
      printf("%f, %f\n", h_idata[i], h_odata[i]);
    }

    // メモリ領域解放
    free(h_idata);
    free(h_odata);
    cudaFree(d_idata);
    cudaFree(d_odata);

    return (0);
}


