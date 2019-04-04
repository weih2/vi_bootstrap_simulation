#include<string>
#include<cmath>
#include<random>
#include<iostream>
#include<ostream>
#include<fstream>

// cuda official libraries
#include "cuda.h"
#include <thrust/execution_policy.h>
#include <thrust/sort.h>
#include <curand_kernel.h>

// my own header files
#include "par_format.h"
#include "./parallel/device_par_format.h"

// global settings
#include "simulation_settings.cpp"

#include "./parallel/device_cavi_implementation.h"
#include "bridge.h"



// utility functions
#include "random_pack.cpp"
#include "./utils/gen_data.cpp"
#include "./utils/sample_quantile.cu"

// parallel implementations
#include "./parallel/device_initialization.cu"
#include "./parallel/device_utils/device_generate_weights.cu"
#include "./parallel/device_utils/device_cavi_update.cu"
#include "./parallel/device_utils/device_cavi_point_estimate.cu"

// host implementations
#include "init_bridge.cu"
#include "cavi_execution.cu"
