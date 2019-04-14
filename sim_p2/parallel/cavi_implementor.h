class cavi_implementor{
public:
  __device__ cavi_implementor();

  // will be stored in global memory
  observations obs;

  double weights[n];
  global_pars true_pars;
  hyper_prior_pars prior_pars;

  vb_posterior_pars posterior_point_est;
  double elbo;

  __device__ void generate_weights();

private:
  int b_count;
};
