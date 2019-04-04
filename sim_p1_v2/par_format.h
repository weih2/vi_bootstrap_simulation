struct global_vars{
  // # categories
  const int K;
  // variance of cluster center
  const double sigma_2;
  // # samples
  const int n_samples;
};

struct latent_vars{
  // cluster centers
  double* mu;
  // categories of each sample
  int* c;
};
