#include <stdio.h>
#include <string.h>

#include "cuda.h"
#include "nvPTXCompiler.h"

#define NUM_THREADS 128
#define NUM_BLOCKS  32
#define VECTOR_SIZE (NUM_THREADS * NUM_BLOCKS)

#define CUDA_SAFE_CALL(x)                                        \
    do {                                                         \
        CUresult result = x;                                     \
        if (result != CUDA_SUCCESS) {                            \
            const char *msg;                                     \
            cuGetErrorName(result, &msg);                        \
            printf("error: %s failed with error %s\n", #x, msg); \
            exit(1);                                             \
        }                                                        \
    } while (0)

#define NVPTXCOMPILER_SAFE_CALL(x)                                       \
    do {                                                                 \
        nvPTXCompileResult result = x;                                   \
        if (result != NVPTXCOMPILE_SUCCESS) {                            \
            printf("error: %s failed with error code %d\n", #x, result); \
            exit(1);                                                     \
        }                                                                \
    } while (0)

/* for H800 */
const char *ptxCode = "                                   \
    .version 8.5                                       \n \
    .target sm_90                                      \n \
    .address_size 64                                   \n \
    .visible .entry vectorAdd(                         \n \
         .param .u64 vectorAdd_param_0,                \n \
         .param .u64 vectorAdd_param_1,                \n \
         .param .u64 vectorAdd_param_2                 \n \
    ) {                                                \n \
         .reg .f32          %f<4>;                     \n \
         .reg .b32          %r<5>;                     \n \
         .reg .b64          %rd<11>;                   \n \
         ld.param.u64       %rd1, [vectorAdd_param_0]; \n \
         ld.param.u64       %rd2, [vectorAdd_param_1]; \n \
         ld.param.u64       %rd3, [vectorAdd_param_2]; \n \
         cvta.to.global.u64 %rd4, %rd3;                \n \
         cvta.to.global.u64 %rd5, %rd2;                \n \
         cvta.to.global.u64 %rd6, %rd1;                \n \
         mov.u32            %r1, %ctaid.x;             \n \
         mov.u32            %r2, %ntid.x;              \n \
         mov.u32            %r3, %tid.x;               \n \
         mad.lo.s32         %r4, %r2, %r1, %r3;        \n \
         mul.wide.u32       %rd7, %r4, 4;              \n \
         add.s64            %rd8, %rd6, %rd7;          \n \
         ld.global.f32      %f1, [%rd8];               \n \
         add.s64            %rd9, %rd5, %rd7;          \n \
         ld.global.f32      %f2, [%rd9];               \n \
         add.f32            %f3, %f1, %f2;             \n \
         add.s64            %rd10, %rd4, %rd7;         \n \
         st.global.f32      [%rd10], %f3;              \n \
         ret;                                          \n \
    }";

void setValue(float hX[VECTOR_SIZE], float hY[VECTOR_SIZE])
{
    for (int i = 0; i < VECTOR_SIZE; ++i) {
        hX[i] = (float)i;
        hY[i] = (float)(VECTOR_SIZE - i);
    }
}

void loadModuleAndRunFun(
    void *elf,
    size_t elfSize,
    const char *fun,
    float hX[VECTOR_SIZE],
    float hY[VECTOR_SIZE],
    float hOut[VECTOR_SIZE]
)
{
    CUDA_SAFE_CALL(cuInit(0));

    CUdevice cuDevice;
    CUDA_SAFE_CALL(cuDeviceGet(&cuDevice, 0));

    CUcontext context;
    CUDA_SAFE_CALL(cuCtxCreate(&context, 0, cuDevice));

    CUmodule module;
    CUDA_SAFE_CALL(cuModuleLoadDataEx(&module, elf, 0, 0, 0));

    CUfunction kernel;
    CUDA_SAFE_CALL(cuModuleGetFunction(&kernel, module, "vectorAdd"));

    // alloc device mem
    size_t bufferSize = VECTOR_SIZE * sizeof(float);
    CUdeviceptr dX, dY, dOut;
    CUDA_SAFE_CALL(cuMemAlloc(&dX, bufferSize));
    CUDA_SAFE_CALL(cuMemAlloc(&dY, bufferSize));
    CUDA_SAFE_CALL(cuMemAlloc(&dOut, bufferSize));

    // copy from host to device
    CUDA_SAFE_CALL(cuMemcpyHtoD(dX, hX, bufferSize));
    CUDA_SAFE_CALL(cuMemcpyHtoD(dY, hY, bufferSize));

    // set paras and launch the kernel
    void *paras[3];
    paras[0] = &dX;
    paras[1] = &dY;
    paras[2] = &dOut;
    CUDA_SAFE_CALL(cuLaunchKernel(
        kernel,
        NUM_BLOCKS,
        1,
        1, // grid dim
        NUM_THREADS,
        1,
        1, // block dim
        0,
        NULL, // shared mem and stream
        paras,
        0
    ));

    // sync all threads
    CUDA_SAFE_CALL(cuCtxSynchronize());

    // copy the result from device to host
    CUDA_SAFE_CALL(cuMemcpyDtoH(hOut, dOut, bufferSize));

    // release resources
    CUDA_SAFE_CALL(cuMemFree(dX));
    CUDA_SAFE_CALL(cuMemFree(dY));
    CUDA_SAFE_CALL(cuMemFree(dOut));
    CUDA_SAFE_CALL(cuModuleUnload(module));
    CUDA_SAFE_CALL(cuCtxDestroy(context));
}

char *compilePtxCode(const char *code, size_t *elfSize)
{
    nvPTXCompileResult status;

    unsigned int majorVer, minorVer;
    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetVersion(&majorVer, &minorVer));
    printf("Current PTX Compiler API Version : %d.%d\n", majorVer, minorVer);

    nvPTXCompilerHandle compiler;
    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerCreate(&compiler, (size_t)strlen(code), code));

    // must match the `.target` in code and the gpu hardware
    const char *compile_options[] = {"--gpu-name=sm_90", "--verbose"};
    status = nvPTXCompilerCompile(compiler, 2, compile_options);
    if (status != NVPTXCOMPILE_SUCCESS) {
        size_t errorSize;
        NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetErrorLogSize(compiler, &errorSize));
        if (errorSize != 0) {
            char *errorLog = malloc(errorSize + 1);
            NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetErrorLog(compiler, errorLog));
            printf("Error log: %s\n", errorLog);
            free(errorLog);
        }
        exit(1);
    }

    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetCompiledProgramSize(compiler, elfSize));
    char *elf = (char *)malloc(*elfSize);
    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetCompiledProgram(compiler, (void *)elf));

    size_t infoSize;
    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetInfoLogSize(compiler, &infoSize));
    if (infoSize != 0) {
        char *infoLog = (char *)malloc(infoSize + 1);
        NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerGetInfoLog(compiler, infoLog));
        printf("Info log: %s\n", infoLog);
        free(infoLog);
    }

    NVPTXCOMPILER_SAFE_CALL(nvPTXCompilerDestroy(&compiler));
    return elf;
}

int main(int _argc, char *_argv[])
{

    size_t elfSize;
    char *elf = compilePtxCode(ptxCode, &elfSize);

    float hX[VECTOR_SIZE], hY[VECTOR_SIZE], hOut[VECTOR_SIZE];
    setValue(hX, hY);

    loadModuleAndRunFun(elf, elfSize, "vectorAdd", hX, hY, hOut);

    printf("The result is:");
    for (size_t i = 0; i < VECTOR_SIZE; ++i) {
        if (i % 16 == 0) {
            printf("\n%5ld: ", i);
        }
        printf("%7.1f ", hOut[i]);
    }
    printf("\n");

    free(elf);
    return 0;
}
