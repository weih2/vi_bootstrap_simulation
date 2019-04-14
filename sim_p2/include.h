#include<random>
#include<cmath>

// cuda official libraries
#include "cuda.h"
#include <thrust/execution_policy.h>
#include <thrust/sort.h>
#include <curand_kernel.h>

#include "par_foramat.h"
#include "simulation_settings.h"

#include "bridge.h"

#include "./parallel/cavi_implementor.h"
