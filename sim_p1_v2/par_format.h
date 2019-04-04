struct global_vars{
  // # categories
  int K;
  // variance of cluster center
  double sigma_2;
  // # samples
  int n_samples;
};

struct latent_vars{
  // cluster centers
  double* mu;
  // categories of each sample
  int* c;
};
