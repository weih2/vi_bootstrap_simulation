#define PRIOR_SIGMA2 15.

#include <cuda.h>
#include <thrust/execution_policy.h>
#include <thrust/sort.h>

#include <curand_kernel.h>

#include "device_mcmc_implementor.cuh"

#include "./mcmc_utils/gen_obs.cu"
#include "./mcmc_utils/gen_mcmc_samples.cu"
