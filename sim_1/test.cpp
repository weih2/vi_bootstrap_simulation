#include "include.h"

using namespace std;

int main(){
  simulation_data sim1;
  sim1.g_vars.n_samples = 10;
  sim1.g_vars.K = 2;
  sim1.g_vars.sigma_2 = 4;

  generate_latent_pars(sim1);
  generate_data(sim1);
  generate_weights(sim1);

  cavi_implementation sim0(sim1);

  cout << sim0.data.x[0] << endl; 
  int n_steps = 1;
  sim0.cavi_update(n_steps);
  return 0;
}
