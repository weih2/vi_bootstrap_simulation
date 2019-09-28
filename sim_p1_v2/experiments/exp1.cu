#include "../include.h"
#include "fixed_latent_vars_generation.cpp"
#define DELTA_COUNT 51

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

    double vwlb_cs_covered_counts_total[DELTA_COUNT];
    double vp_cs_covered_counts_total[DELTA_COUNT];
    double empirical_ci_covered_counts_total[DELTA_COUNT];
    double vwlb_cs2_covered_counts_total[DELTA_COUNT];

    int n_outliers[DELTA_COUNT];

    bridge bridge_settings(dev_settings);
    bridge_settings.save_settings(std::cout);
    bridge_settings.clean_device();

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      fixed_latent_vars_generation(dev_settings.l_vars,
        exp(-3 + delta_count * 0.1));

      bridge bridge_0(dev_settings);

      bridge_0.connect_to_execution();

      for(int k = 0; k < K; k++){
        vwlb_cs_covered_counts_total[delta_count] = 0;
        vp_cs_covered_counts_total[delta_count] = 0;
        empirical_ci_covered_counts_total[delta_count] = 0;
        vwlb_cs2_covered_counts_total[delta_count] = 0;
      }

      n_outliers[delta_count] = bridge_0.n_outliers;

      for(int k = 0; k < K; k++){
        vwlb_cs_covered_counts_total[delta_count]
         += bridge_0.vwlb_cs_covered_counts[k];
        vp_cs_covered_counts_total[delta_count]
         += bridge_0.vp_cs_covered_counts[k];
       vwlb_cs2_covered_counts_total[delta_count]
         += bridge_0.vwlb_cs2_covered_counts[k];
        empirical_ci_covered_counts_total[delta_count]
         += bridge_0.empirical_ci_covered_counts[k];
      }

      bridge_0.clean_device();
      printf("experiments #%d is done\n", delta_count);
    }

    printf("number of outliers in each experiment: \n");

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++)
      printf("%d ", n_outliers[delta_count]);
    printf("\n");

    int n_effective;
    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      n_effective = n_experiments - n_outliers[delta_count];
      vwlb_cs_covered_counts_total[delta_count] /= double(K * n_effective);
      vp_cs_covered_counts_total[delta_count] /= double(K * n_effective);
      empirical_ci_covered_counts_total[delta_count] /= double(K * n_effective);
      vwlb_cs2_covered_counts_total[delta_count] /= double(K * n_effective);
      printf("%f ", vwlb_cs_covered_counts_total[delta_count]);
    }
    printf("\n");

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      printf("%f ", vwlb_cs2_covered_counts_total[delta_count]);
    }

    printf("\n");

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      printf("%f ", vp_cs_covered_counts_total[delta_count]);
    }

    printf("\n");

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      printf("%f ", empirical_ci_covered_counts_total[delta_count]);
    }

  return 0;
}
