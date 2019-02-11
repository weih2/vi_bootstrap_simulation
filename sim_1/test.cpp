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

  for(int i = 0; i < 10; i++) cout << sim1.x[i] << endl;
  for(int i = 0; i < 10; i++) cout << sim1.b_vars.weights[i] << endl;
  return 0;
}
