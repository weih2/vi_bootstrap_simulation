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

    bridge bridge_0(dev_settings);

    bridge_0.connect_to_execution();

    bridge_0.save_result(std::cout);

  result_stream.close();

  return 0;
}
