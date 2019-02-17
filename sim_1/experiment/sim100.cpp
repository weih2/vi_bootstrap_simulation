#include "../include.h"

#define N_SAMPLES 200

int main(){
  simulation_data data100;
  data100.g_vars.n_samples = N_SAMPLES;
  data100.g_vars.K = 2;
  data100.g_vars.sigma_2 = 9;

  data100.b_vars.confidence = 0.95;

  generate_latent_pars(data100);

  cavi_implementation sim100(data100, N_SAMPLES);

  int n_steps = 1000;

  int n_experiments = 200;

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
  cout << endl;

  ofstream result_stream;
  result_stream.open("simulation200.txt", ofstream::out | ofstream::app);
  // result_stream.open(file_name, ofstream::out | ofstream::app);
  sim100.save_result(result_stream);
  result_stream.close();

  return 0;
}
