__device__ device_mcmc_implementor::device_mcmc_implementor(double delta, int t_id){
  thread_id = t_id;

  mu[0] = -delta;
  mu[1] = 0;
  mu[2] = delta;
}
