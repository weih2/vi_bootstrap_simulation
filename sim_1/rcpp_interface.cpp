#include <Rcpp.h>
#include "include.h"

using namespace Rcpp;
using namespace std;

// [[Rcpp::export]]
void test(){
  simulation_data sim1;
  sim1.g_vars.n_samples = 10000;
  sim1.g_vars.K = 2;
  sim1.g_vars.sigma_2 = 9;
  
  generate_latent_pars(sim1);
  generate_data(sim1);
  generate_weights(sim1);
  
  cavi_implementation sim0(sim1);
  cavi_implementation sim2(sim1);
  
  int n_steps = 1000;
  sim0.cavi_update(n_steps);
  sim2.cavi_update(n_steps);
  
  Rcout << "true latent means: " << sim1.l_vars.mu[0] << " and " << sim1.l_vars.mu[1] << endl;
  Rcout << "vb posterior means: " << sim0.est.m[0] << " and " << sim0.est.m[1] << endl;
  Rcout << "another vb posterior means: " << sim2.est.m[0] << " and " << sim2.est.m[1] << endl;
  
  // sim0.cavi_bootstrap_update(n_steps);
}
