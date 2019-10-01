#define PRIOR_SIGMA2 15.

#include <cuda.h>
#include <thrust/execution_policy.h>
#include <thrust/sort.h>

#include <curand_kernel.h>

#include "device_mcmc_implementor.cuh"
#include "device_mcmc_init.cu"
#include "./mcmc_utils/mcmc_utils_include.h"

#include "connect_execution.cu"
