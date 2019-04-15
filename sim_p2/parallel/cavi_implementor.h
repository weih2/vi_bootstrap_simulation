class cavi_implementor{
public:
  __device__ cavi_implementor(device_settings, int);
  int thread_id;

  // will be stored in global memory
  double* x;

  double y[n];
  double weights[n];
  global_pars true_pars;

  double importance_weights[n_sigma_2 * n_sigma_b_2 * n_pi];

  vb_posterior_pars posterior_point_est;
  double elbo;

  __device__ void generate_y();

  __device__ void generate_weights();
  __device__ void importance_sampling();
  __device__ void importance_sampling_weighted();

private:
  int b_count;

  global_pars current_pars;

  __device__ void cavi_point_estimate();
  __device__ void cavi_point_estimate_update();
  __device__ void update_elbo();
};
