#include<string>
#include<cmath>
#include<random>
#include<iostream>
#include<ostream>
#include<fstream>
#include<queue>

#include <chrono>
#include <ctime>

#include <gsl/gsl_sort_double.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_cdf.h>

// global setting
#define BUFF 200.

#include "par_format.h"
#include "random_pack.cpp"
#include "gen_data.cpp"
#include "init_cavi.cpp"

#include "cavi_estimate.cpp"
#include "cavi_estimate_weighted.cpp"
#include "ci_construct.cpp"
#include "cs_construct.cpp"
#include "empirical_ci_construct.cpp"
#include "check_covered.cpp"

#include "save_result.cpp"
