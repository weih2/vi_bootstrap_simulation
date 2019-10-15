#include "../include.h"
#include "fixed_latent_vars_generation.cpp"
#define DELTA_COUNT 10

#include<fstream>

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
    double vwlb_cs2_covered_counts_total[DELTA_COUNT];
    double vp_cs_covered_counts_total[DELTA_COUNT];
    double empirical_ci_covered_counts_total[DELTA_COUNT];

    bridge bridge_settings(dev_settings);
    bridge_settings.clean_device();

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      fixed_latent_vars_generation(dev_settings.l_vars,
        (delta_count + 1) * 0.5);

      bridge bridge_0(dev_settings);

      bridge_0.connect_to_analysis();

      for(int k = 0; k < N_CLUSTERS; k++){
        vwlb_cs_covered_counts_total[delta_count] = 0;
        vwlb_cs2_covered_counts_total[delta_count] = 0;
        vp_cs_covered_counts_total[delta_count] = 0;
        empirical_ci_covered_counts_total[delta_count] = 0;
      }

      for(int k = 0; k < N_CLUSTERS; k++){
        vwlb_cs_covered_counts_total[delta_count]
         += bridge_0.vwlb_cs_covered_counts[k];
        vwlb_cs2_covered_counts_total[delta_count]
        += bridge_0.vwlb_cs2_covered_counts[k];
        vp_cs_covered_counts_total[delta_count]
         += bridge_0.vp_cs_covered_counts[k];
        empirical_ci_covered_counts_total[delta_count]
         += bridge_0.empirical_ci_covered_counts[k];
      }

      bridge_0.clean_device();

      bridge_settings.save_settings(std::cout);
      printf("\n vwlb cs lengths");
      for(int k = 0; k < N_CLUSTERS; k++){
        for(int i = 0; i < n_experiments/4; i++){
          if(bridge_0.is_outlier[i]) continue;
          printf("%f ", bridge_0.vwlb_cs_lengths[k * n_experiments + i]);
        }
        printf("\n");

        printf("mean is %f\n", cal_mean(bridge_0.vwlb_cs_lengths, n_experiments));
        printf("var is %f\n", cal_variance(bridge_0.vwlb_cs_lengths, n_experiments));
      }
      printf("\n vwlb cs2 lengths");
      for(int k = 0; k < N_CLUSTERS; k++){
        for(int i = 0; i < n_experiments/4; i++){
          if(bridge_0.is_outlier[i]) continue;
          printf("%f ", bridge_0.vwlb_cs2_lengths[k * n_experiments + i]);
        }
        printf("\n");
      }
      printf("\n vp cs lengths");
      for(int k = 0; k < N_CLUSTERS; k++){
        for(int i = 0; i < n_experiments/4; i++){
          if(bridge_0.is_outlier[i]) continue;
          printf("%f ", bridge_0.vp_cs_lengths[k * n_experiments + i]);
        }
        printf("\n");
      }
      printf("\n emirical cs lengths");
      for(int k = 0; k < N_CLUSTERS; k++){
        printf("%f ", bridge_0.empirical_ci[k][1] - bridge_0.empirical_ci[k][0]);
      }
      printf("\nexperiments #%d is done\n", delta_count);
    }

    for(int delta_count = 0; delta_count < DELTA_COUNT; delta_count++){
      vwlb_cs_covered_counts_total[delta_count] /= double(N_CLUSTERS * n_experiments);
      vwlb_cs2_covered_counts_total[delta_count] /= double(N_CLUSTERS * n_experiments);
      vp_cs_covered_counts_total[delta_count] /= double(N_CLUSTERS * n_experiments);
      empirical_ci_covered_counts_total[delta_count] /= double(N_CLUSTERS * n_experiments);
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
