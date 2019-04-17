__device__ __host__ inline double cal_mean(const double *observations, int n_observations){
  double mean = 0;
  for(int o = 0; o < n_observations; o++){
    mean += observations[o];
  }
  mean /= double(n_observations);
  return mean;
}

__device__ __host__ inline double cal_variance(const double *observations, int n_observations){
  double mean = cal_mean(observations, n_observations);

  double variance = 0;
  for(int o = 0; o < n_observations; o++){
    variance += (observations[o] - mean) * (observations[o] - mean);
  }
  variance /= double(n_observations - 1);
  return variance;
}
