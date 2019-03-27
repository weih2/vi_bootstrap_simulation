#include<string>
#include<cmath>
#include<random>
#include<iostream>
#include<ostream>
#include<fstream>
#include<queue>

#include <chrono>
#include <ctime>

#include "cuda.h"
#include <thrust/sort.h>
#include <curand_kernel.h>

#include "par_format.h"

#include "./utils/sample_quantile.cpp"
#include "./utils/gaussian_quantile.cpp"
#include "./utils/device_compute.cu"

/*
#include <gsl/gsl_sort_double.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_cdf.h>
*/

#include "cavi_implementation.h"
#include "random_pack.cpp"
#include "gen_data.cpp"
#include "init_cavi.cpp"

#include "cavi_estimate.cpp"
// #include "cavi_estimate_weighted.cpp"
#include "cavi_estimate_weighted_device.cu"
#include "ci_construct.cpp"
#include "cs_construct.cpp"
#include "empirical_ci_construct.cpp"
#include "check_covered.cpp"

#include "save_result.cpp"
