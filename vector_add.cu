#include <iostream>
using namespace std;

__global__ 
void VecAdd(int* A, int* B, int* C) {
    int i = threadIdx.x;
    printf("Thread Id: %d\n", i);
    C[i] = A[i] + B[i];
}

void printVector(int* A, int len) {
    for(int i=0; i<len; i++) {
        cout << A[i] << ' ';
    }
    cout << endl;
}

int main() {
    int N = 4;

    int A[N] = {1,2,3,4};
    int B[N] = {1,2,3,4};
    int C[N] = {0,0,0,0};

    // Initialize data on device
    int *A_d, *B_d, *C_d;
    cudaMalloc((void **)&A_d, N*sizeof(int));
    cudaMalloc((void **)&B_d, N*sizeof(int));
    cudaMalloc((void **)&C_d, N*sizeof(int));

    // Copy data from cpu to gpu
    cudaMemcpy(A_d, A, N*sizeof(int),cudaMemcpyDefault);
    cudaMemcpy(B_d, B, N*sizeof(int),cudaMemcpyDefault);
    cudaMemcpy(C_d, C, N*sizeof(int),cudaMemcpyDefault);


    // Call Kernel method
    VecAdd<<<1, N>>>(A_d, B_d, C_d);

    // Copy data from gpu to cpu
    cudaMemcpy(A, A_d, N*sizeof(int),cudaMemcpyDefault);
    cudaMemcpy(B, B_d, N*sizeof(int),cudaMemcpyDefault);
    cudaMemcpy(C, C_d, N*sizeof(int),cudaMemcpyDefault);
    

    printVector(A, N);
    printVector(B, N);
    printVector(C, N);
    

    return 0;
}