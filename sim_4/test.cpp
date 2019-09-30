# include "include.h"

using namespace std;
int main(){
  device_mcmc_implementor test_implementor(1);

  test_implementor.gen_obs();
  for(int i = 0; i < N_OBS; i++){
    cout << test_implementor.obs[i] << endl;
  }
  test_implementor.gen_mcmc_samples();

  for(int k = 0; k < K ; k++){
    cout << test_implementor.mu_samples[k][N_MCMC_SAMPLES - 1] << endl;
  }
  return 0;
}
