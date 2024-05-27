#include <cuda_runtime.h>
#include <stdio.h>
#include <exception>
#include <cmath>
#include <iostream>
#include "Matrix.cuh"

bool isCorrectAnswer(Matrix const& m, float val, float eps = 1e-6)
{
    for (size_t i = 0; i < m.hight(); i++) {
        for (size_t j = 0; j < m.width(); j++) {
            if (std::abs(m.at(i, j) - val) > eps)
                return false;
        }
    }
    return true;
}

void printMatrix(Matrix const& m) 
{
    for (size_t i = 0; i < m.hight(); ++i)
    {
        for (size_t j = 0; j < m.width(); ++j)
        {
            std::cout << m.at(i, j) << '\t';
        }
        std::cout << std::endl;
    }
}

int main()
{
    try 
    {
        size_t s =  1 << 10;
        Matrix m1 = Matrix::full(1.f, s*2, s);
        Matrix m2 = Matrix::full(1.f, s, s);
        Matrix m3 = m1.mul(m2, Matrix::MulMode::SHARED);

        /*printMatrix(m1);
        std::cout << '*' << std::endl;
        printMatrix(m2);
        std::cout << '=' << std::endl;
        printMatrix(m3);*/

        if (isCorrectAnswer(m3, (float)s))
            printf("CORRECT");
        else
            printf("WRONG");
        printf(" ANSWER\n");

        // cudaDeviceReset must be called before exiting in order for profiling and
        // tracing tools such as Nsight and Visual Profiler to show complete traces.
        cudaError_t cudaStatus = cudaDeviceReset();
        if (cudaStatus != cudaSuccess) {
            fprintf(stderr, "cudaDeviceReset failed!");
            return 1;
        }
    }
    catch (std::exception& e) 
    {
        fprintf(stderr, e.what());
        return -1;
    }

    return 0;
}