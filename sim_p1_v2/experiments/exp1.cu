#include "../include.h"
#include "fixed_latent_vars_generation.cpp"

int main(){
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

  for(int delta_count = 50; delta_count <= 51; delta_count++){
    // delta_i = 0.1 * i
    delta = delta_count * 0.1;
    // fixed_latent_vars_generation(dev_settings.l_vars, delta);
    // bridge_0.save_settings(cout);

    bridge_0.connect_to_execution();

    coverage_vwlb[delta_count] = 0;
    coverage_vp[delta_count] = 0;

    for(int k = 0; k < K; k++){
      printf("%d\n", bridge_0.vwlb_cs_covered_counts[k]);
      coverage_vwlb[delta_count - 1] += bridge_0.vwlb_cs_covered_counts[k];
      coverage_vp[delta_count - 1] += bridge_0.vp_cs_covered_counts[k];
    }

    coverage_vwlb[delta_count - 1] /= double(K * n_experiments);
    coverage_vp[delta_count - 1] /= double(K * n_experiments);

  }

  return 0;
}
