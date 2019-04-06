#include "../include.h"
#include "fixed_latent_vars_generation.cpp"

using namespace std;

int main(){
  ofstream result_stream;
  result_stream.open("simulation_result.txt", ofstream::out | ofstream::app);

  latent_vars true_vars;
  generate_latent_pars(true_vars);

  device_settings dev_settings;
  dev_settings.l_vars = true_vars;

  dev_settings.epsilon = new double();
  *dev_settings.epsilon = 0.001;

  dev_settings.max_n_iter = new int();
  *dev_settings.max_n_iter = 100;

  dev_settings.bootstrap_confidence = new double();
  *dev_settings.bootstrap_confidence = 0.95;

  dev_settings.ci_quantile = new double();
  *dev_settings.ci_quantile = cdf_ugaussian_Pinv(0.975);

  double delta;
  bridge bridge_0(dev_settings);
  double coverage_vwlb[100];
  double coverage_vp[100];

  for(int delta_count = 1; delta_count <= 100; delta_count++){
    // delta_i = 0.1 * i
    delta = delta_count * 0.1;
    fixed_latent_vars_generation(dev_settings.l_vars, delta);

    bridge_0 = bridge(dev_settings);

    bridge_0.connect_to_execution();
    bridge_0.clean_device();

    coverage_vwlb[delta_count] = 0;
    coverage_vp[delta_count] = 0;

    for(int k = 0; k < K; k++){
      coverage_vwlb[delta_count] += bridge_0.vwlb_cs_covered_counts[k];
      coverage_vp[delta_count] += bridge_0.vp_cs_covered_counts[k];
    }
    coverage_vwlb[delta_count] /= double(K * n_experiments);
    coverage_vp[delta_count] /= double(K * n_experiments);
  }

  for(int delta_count = 1; delta_count <= 100; delta_count++){
    result_stream << coverage_vwlb[delta_count] << " ";
  }
  result_stream << endl;

  for(int delta_count = 1; delta_count <= 100; delta_count++){
    result_stream << coverage_vwlb[delta_count] << " " << endl;
  }
  result_stream << endl;

  result_stream.close();

  return 0;
}
