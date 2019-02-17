#include<string>
#include<cmath>
#include<random>
#include<iostream>
#include<ostream>
#include<fstream>

#include <gsl/gsl_sort_double.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_cdf.h>

#include "par_format.h"
#include "random_pack.cpp"
#include "gen_data.cpp"
#include "init_cavi.cpp"

#include "cavi_estimate.cpp"
#include "cavi_estimate_weighted.cpp"
#include "ci_construct.cpp"
#include "cs_construct.cpp"
#include "check_covered.cpp"

#include "save_result.cpp"
