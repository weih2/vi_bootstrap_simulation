#include "../include.h"

#define N_SAMPLES 500
#define DELTA 1.

int main(){
  simulation_data data100;
  data100.g_vars.n_samples = N_SAMPLES;
  data100.g_vars.K = 3;
  data100.g_vars.sigma_2 = 10;

  data100.b_vars.confidence = 0.95;

  generate_latent_pars(data100);
  data100.l_vars.mu[0] = -DELTA;
  data100.l_vars.mu[1] = 0;
  data100.l_vars.mu[2] = DELTA;

  cavi_implementation sim100(data100, 1000);

  int n_steps = 100;

  // just need one
  int n_experiments = 1;

  cout << "total no of experiments: " << n_experiments << endl;

  for(int n_e = 0; n_e < n_experiments; n_e ++){
    if((n_e + 1) % 10 == 0) cout << "experiment no." << n_e + 1 << endl;
    // generate data
    generate_data(sim100.data);

    sim100.cavi_update(n_steps);
    sim100.cavi_bootstrap_update(n_steps);

    sim100.ci_construct();
    sim100.cs_construct();

    sim100.check_covered();
  }

  sim100.empirical_ci_construct();
  cout << endl;

  // ofstream result_stream;
  // result_stream.open("simulation500.txt", ofstream::out | ofstream::app);
  // result_stream.open(file_name, ofstream::out | ofstream::app);
  sim100.save_result(cout);
  // result_stream.close();

  return 0;
}
