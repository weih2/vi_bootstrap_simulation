#include "include.h"

using namespace std;

int main(){
  simulation_data sim1;
  sim1.g_vars.n_samples = 1000;
  sim1.g_vars.K = 2;
  sim1.g_vars.sigma_2 = 4;

  generate_latent_pars(sim1);
  generate_data(sim1);
  generate_weights(sim1);

  cavi_implementation sim0(sim1);

  int n_steps = 1000;
  sim0.cavi_update(n_steps);

  cout << "true latent means: " << sim1.l_vars.mu[0] << " and " << sim1.l_vars.mu[1] << endl;
  cout << "vb posterior means: " << sim0.est.m[0] << " and " << sim0.est.m[1] << endl;
  return 0;
}
